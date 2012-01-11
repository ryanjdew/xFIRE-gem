xquery version "1.0-ml" ;

(:~
 :
 : This module is used to mimic layout, yield, and content-for in Ruby on Rails
 :
 : @author Ryan Dew (ryan.j.dew@gmail.com)
 : @version 0.1
 :
 :)

 module namespace layout = "/xFire/layout";

 declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";

(: Use the yield-map to track session fields to clear at the end of a request :)
declare variable $yield-map := map:map();
(: default layout for the application :)
declare variable $default-layout := '/resource/views/layouts/application';

declare function content-for($area as xs:string, $content as item()*) {
	(: use the request id to avoid potential collisons:)
	let $key := fn:concat($area, '-', xdmp:request())
	let $_ := (map:put($yield-map, $key, ()),
			   xdmp:set-session-field($key, $content))
	return ()
};

declare function yield($area as xs:string) {
	xdmp:get-session-field(fn:concat($area, '-', xdmp:request()))
};

declare function content-body($content as item()*) {
	let $key := fn:concat('page-content-body-', xdmp:request())
	let $_ := (map:put($yield-map, $key, ()),
				xdmp:set-session-field($key, $content))
	return ()
};

declare function yield() {
	xdmp:get-session-field(fn:concat('page-content-body-', xdmp:request()))
};

declare function layout($layout-path as xs:string?) {
	let $key := fn:concat('layout-', xdmp:request())
	let $_ := (map:put($yield-map, $key, ()),
				xdmp:set-session-field($key, $layout-path))
	return ()
};

declare function layout() {
	fn:concat(
		(xdmp:get-session-field(fn:concat('layout-', xdmp:request())),$default-layout)[1],
		'.',
		type(),
		'.xsl'
	)
};

declare function clear-session-fields() as empty-sequence() {
	for $k in map:keys($yield-map)
	return xdmp:set-session-field($k, ())
};

declare function type() as xs:string {
	let $key := fn:concat('render-type-', xdmp:request())
	let $cached-type := xdmp:get-session-field($key)
	return if (fn:exists($cached-type))
			then $cached-type
			else (map:put($yield-map, $key, ()),
					xdmp:set-session-field($key, 'html'))
};

declare function render-partial($target as xs:string) as node()? {
	render-partial($target, ())
};

declare function render-partial($target as xs:string, $transform-items as node()*) as node()? {
	let $template-xsl := fn:concat($target,'.',type(),'.xsl')
	return if (fn:exists($transform-items))
			then for $i in $transform-items
				 return xdmp:xslt-invoke($template-xsl, $i, request-fields())
			else xdmp:xslt-invoke($template-xsl, (), request-fields())
};

declare function render-page($target as xs:string) as node()? {
	let $query-xsl := fn:concat($target,'.query.xsl')
	let $doc := if (xdmp:uri-is-file($query-xsl)) 
				then fn:doc(cts:uris('/', (), cts:query(xdmp:xslt-invoke($query-xsl, element e {}, request-fields())/*)))/* 
				else ()
	let $type := type()
	let $view-xsl := fn:concat($target,'.',$type,'.xsl')
	return 
		if (xdmp:uri-is-file($view-xsl) and fn:exists($doc))
		then 
			let $layout := layout()
			return
			if ($layout eq 'none')
			then xdmp:xslt-invoke($view-xsl, $doc, request-fields())
			else
			(
				layout:content-body(xdmp:xslt-invoke($view-xsl, $doc, request-fields())),
				xdmp:xslt-invoke(layout:layout(), element e {}, request-fields()),
				clear-session-fields()
			)
		else xdmp:redirect-response('/errror.xqy?reason=404')
};

declare function request-fields() as map:map? {
	xdmp:get-session-field(fn:concat('request-fields',xdmp:request()))
};

declare function request-fields($request-fields as map:map?) as map:map? {
	let $key := fn:concat('request-fields',xdmp:request())
	return
	(map:put($yield-map, $key, ()),
	xdmp:set-session-field(fn:concat('request-fields',xdmp:request()),$request-fields))
};
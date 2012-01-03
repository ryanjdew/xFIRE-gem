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

(: Use the yeild-map to track session fields to clear at the end of a request :)
declare variable $yield-map := map:map();
(: default layout for the application :)
declare variable $default-layout := '/resource/views/layouts/application.layout';

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

declare function layout($layout-path as xs:string?, $type as xs:string) {
	fn:concat(($layout-path,$default-layout)[1],'.',$type)
};

declare function clear-session-fields() {
	for $k in map:keys($yield-map)
	return xdmp:set-session-field($k, ())
};

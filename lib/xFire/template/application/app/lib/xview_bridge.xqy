xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";

declare variable $request-fields := map:map();

let $xview-url := xdmp:get-request-field('xview-url')
let $_ := fn:tokenize(fn:substring-after($xview-url,'?'),'&amp;')[map:put($request-fields, fn:substring-before(., '='),fn:substring-after(., '='))]
let $target := fn:concat(if (fn:contains($xview-url,'?')) then fn:substring-before($xview-url,'?') else $xview-url,'.',fn:substring-after(fn:tokenize(fn:tokenize(xdmp:get-request-header('Accept', 'text/html'),';')[1],',')[1],'/'))
let $template := xdmp:document-get(fn:concat(fn:replace(xdmp:modules-root(),'/$',''), $target), 
					<options xmlns="xdmp:document-get">
						<format>xml</format>
					</options>
				)/xview
let $type := fn:substring-after($target,'xview.')
let $doc := if (fn:exists($template/doc-query)) then fn:doc(cts:uris('/', (), cts:query(xdmp:xslt-eval(document {$template/doc-query/xsl:stylesheet}/*[1], element cts-query {}, $request-fields)/*)))/* else ()
return ( xdmp:set-response-content-type(if ($type eq 'html') then 'text/html' else fn:concat('application/',$type)),
	if (fn:exists($template) and fn:exists($template/doc-query) and fn:exists($doc))
	then (layout:content-body(xdmp:xslt-eval(document {$template/page/xsl:stylesheet}/node(), $doc, $request-fields)),
		  xdmp:xslt-eval(
			document {
			xdmp:document-get(fn:concat(fn:replace(xdmp:modules-root(),'/$',''),layout:layout($template/@layout, $type)), 
					<options xmlns="xdmp:document-get">
						<format>xml</format>
					</options>
			)/layout/xsl:stylesheet }/*, element layout {}, $request-fields),
			layout:clear-session-fields())
	else xdmp:redirect-response('/errror.xqy?reason=404'))
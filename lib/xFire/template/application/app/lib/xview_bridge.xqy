xquery version "1.0-ml";

import module namespace layout = "/xFire/layout" at "/lib/layout.xqy";

declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";

declare variable $request-fields := map:map();

let $target := xdmp:get-request-field('xviewUrl')
let $template := xdmp:document-get(fn:concat(fn:replace(xdmp:modules-root(),'/$',''),if (fn:contains($target,'?')) then fn:substring-before($target,'?') else $target), 
					<options xmlns="xdmp:document-get">
						<format>xml</format>
					</options>
				)/xview
let $_ := fn:tokenize(fn:substring-after($target,'?'),'&amp;')[map:put($request-fields, fn:substring-before(., '='),fn:substring-after(., '='))]
let $doc := if (fn:exists($template/doc-query)) then fn:doc(cts:uris('/', (), cts:query(xdmp:xslt-eval(document {$template/doc-query/xsl:stylesheet}/*, element cts-query {}, $request-fields)/*)))/* else ()
return  if (fn:exists($template/doc-query) and fn:exists($doc))
	then (layout:content-body(xdmp:xslt-eval(document {$template/page/xsl:stylesheet}/*, if (fn:exists($doc)) then $doc else document {" "}, $request-fields)),
		  xdmp:xslt-eval(
			document {
			xdmp:document-get(fn:concat(fn:replace(xdmp:modules-root(),'/$',''),layout:layout()), 
					<options xmlns="xdmp:document-get">
						<format>xml</format>
					</options>
			)/layout/xsl:stylesheet }/*, element layout {}, $request-fields),
			layout:clear-session-fields())
	else xdmp:redirect-response('/errror.xqy')
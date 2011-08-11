xquery version "1.0-ml" ;

import module namespace r = "routes.xqy" at "/lib/routes.xqy";

let $cachedPath := xdmp:get-server-field('routeCfgPath')
let $routePath := if ($cachedPath) then ($cachedPath) else (xdmp:set-server-field('routeCfgPath',fn:concat(fn:replace(xdmp:modules-root(),'/$',''),'/config/routes.xml')))
let $routesCfg := xdmp:document-get($routePath)
let $selectedRoute := r:selectedRoute($routesCfg)

return if (fn:starts-with($selectedRoute, '/static')) 
	   then $selectedRoute
	   else fn:concat("/lib/xquery_bridge.xqy?requestUrl=",fn:replace($selectedRoute,'\?','&amp;'))
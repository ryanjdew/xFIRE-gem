xquery version "1.0-ml"; 

declare variable $deployScript as xs:string := xdmp:get-request-field('app_xml');

let $application := xdmp:unquote(xdmp:filesystem-file($deployScript))/application


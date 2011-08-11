xquery version "1.0-ml";

declare variable $requestFields := map:map();
declare variable $defaultTemplate := '/views/application.xqy';

let $populateRequestFields := xdmp:get-request-field-names()[map:put($requestFields,self::node(), xdmp:get-request-field(self::node()))]

let $invokeTarget := map:get($requestFields,'requestUrl')
let $functions := xdmp:invoke($invokeTarget,(xs:QName('params'),$requestFields))
let $template := if ($functions[1] instance of xs:string) then ($functions[1]) else ($defaultTemplate)
return xdmp:invoke($template,(for $fun in $functions
						where ($fun instance of xdmp:function)
						return (xdmp:function-name($fun), $fun),(xs:QName('params'),$requestFields)))


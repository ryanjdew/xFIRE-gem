xquery version "1.0-ml";

declare variable $params as map:map external;
declare variable $local:head as xdmp:function external;
declare variable $local:body as xdmp:function external;

xdmp:set-response-content-type( "text/html" ),
'<!DOCTYPE html>',
<html>
	<head>
		{xdmp:apply($local:head)}
	</head>
	<body>
		{xdmp:apply($local:body)}
	</body>
</html>

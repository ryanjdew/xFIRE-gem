xquery version "1.0-ml";

declare variable $params as map:map external;

declare function local:head() {
	<title>User Show</title>
};

declare function local:body() {
	<div>
		This the user show
	</div>
};

(xdmp:function(xs:QName('local:head')),xdmp:function(xs:QName('local:body')))
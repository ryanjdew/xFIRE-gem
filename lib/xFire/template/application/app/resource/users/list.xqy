xquery version "1.0-ml";

declare variable $params as map:map external;

declare function local:head() {
	<title>User List</title>
};

declare function local:body() {
	<div>
		This the user list
	</div>
};

('/views/users.xqy',xdmp:function(xs:QName('local:head')),xdmp:function(xs:QName('local:body')))
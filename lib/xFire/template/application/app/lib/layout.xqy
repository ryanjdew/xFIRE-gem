xquery version "1.0-ml" ;

module namespace layout = "/xFire/layout";

declare variable $yield-map := map:map();
declare variable $default-layout := '/resource/views/layouts/application.layout';

declare function content-for($area as xs:string, $content as item()*) {
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

declare function layout() {
	xdmp:get-session-field(fn:concat('page-layout-', xdmp:request()), $default-layout)
};

declare function layout($layout-path as xs:string) {
	let $key := fn:concat('page-layout-', xdmp:request())
	let $_ := (map:put($yield-map, $key, ()),
				xdmp:set-session-field($key, $layout-path))
	return ()
};

declare function clear-session-fields() {
	for $k in map:keys($yield-map)
	return xdmp:set-session-field($k, ())
};

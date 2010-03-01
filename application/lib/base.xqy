(:
 : Base functions for RDBC core
 :
 : Copyright (c) 2010 Nuno Job [about.nunojob.com]. All Rights Reserved.
 :
 : Licensed under the Apache License, Version 2.0 (the "License");
 : you may not use this file except in compliance with the License.
 : You may obtain a copy of the License at
 :
 : http://www.apache.org/licenses/LICENSE-2.0
 :
 : Unless required by applicable law or agreed to in writing, software
 : distributed under the License is distributed on an "AS IS" BASIS,
 : WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 : See the License for the specific language governing permissions and
 : limitations under the License.
 :
 : The use of the Apache License does not indicate that this project is
 : affiliated with the Apache Software Foundation.
 :)
xquery version "1.0-ml";
module namespace rdbc = "http://ns.dscape.org/2010/rdbc/core";
import module namespace xqhof = "http://ns.dscape.org/2010/xqhof"
  at "xqhof.xqy";

declare variable $content-types := ("application/json","application/xml");
declare variable $default-type  := "application/xml";

(: public - other :)
declare function rdbc:render($resource, $template, $params) {
  let $content-type := rdbc:content-type()
  let $format       := $content-type//rdbc:ext
  let $template     := fn:lower-case($template)
  let $http-code    := ($params//rdbc:http-code, 200) [1]
  let $description  := ($params//rdbc:description, "OK") [1]
  let $uri          := rdbc:q("../templates/$1/$2.$3.xqy", ($resource, $template, $format))
  let $_ := xdmp:set-response-content-type($content-type)
  let $_ := xdmp:set-response-code( $http-code, $description)
  return xdmp:invoke($uri, (xs:QName("params"), if($params) then $params else <rdbc:empty/>),
           <options xmlns="xdmp:eval">
             <isolation>different-transaction</isolation>
             <prevent-deadlocks>true</prevent-deadlocks>
           </options> ) };

declare function rdbc:error($http-code, $description, $stack-trace) {
  rdbc:render('shared', 'error', <rdbc:params>
    <rdbc:http-code> { $http-code } </rdbc:http-code>
    <rdbc:description> { $description } </rdbc:description>
    <rdbc:stack-trace> { $stack-trace } </rdbc:stack-trace> </rdbc:params>) } ;

declare function rdbc:verb() { fn:lower-case( xdmp:get-request-method() ) } ;

declare function rdbc:content-type() {
  let $content-type := ($content-types[.=xdmp:get-request-header("Accept")],$default-type)[1]
  return <rdbc:content-type>
           <rdbc:ext>{fn:tokenize($content-type, "/")[2]}</rdbc:ext>
           { $content-type }
         </rdbc:content-type> } ;

declare function rdbc:route() { xdmp:get-request-path() } ;

declare function rdbc:request() {
  <rdbc:options>
   <rdbc:request>
     <rdbc:header>
       <rdbc:resource>{rdbc:route()}</rdbc:resource>
       { content-type() }
       <rdbc:verb>{verb()}</rdbc:verb>
       <rdbc:client-address> {xdmp:get-request-client-address()} </rdbc:client-address>
       <rdbc:timestamp>{fn:current-dateTime()}</rdbc:timestamp>
         { for $f in xdmp:get-request-header-names()
           return let $sf := fn:lower-case($f)
                  let $vf := xdmp:get-request-header($f)
                  return element {fn:concat("rdbc:", $sf)} 
                                 { if ($sf = "content-type") then () else $vf } }
    </rdbc:header>
    <rdbc:body>
      { for $f in xdmp:get-request-field-names()
        return element {fn:concat("rdbc:", fn:lower-case($f))} {xdmp:get-request-field($f)} }
    </rdbc:body>
    </rdbc:request>
  </rdbc:options> } ;

declare function rdbc:q($str, $opts) {
  for $sub at $i in $opts
    let $x := fn:replace($str, fn:concat("\$", $i), $sub)
    let $_ := xdmp:set($str, $x)
    return (),
  $str
};
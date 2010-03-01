(:
 : Routing rules for for RDBC
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
import module namespace routes = "http://ns.dscape.org/2010/rdbc/cfg/routes" 
  at "../config/routes.xqy";
import module namespace rdbc = "http://ns.dscape.org/2010/rdbc/core"
  at "base.xqy";

declare namespace s="http://www.w3.org/2009/xpath-functions/analyze-string";

(: remember to add public as accessible from outside :)
let $routes   := routes:routes()
let $route    := rdbc:route()
let $selected := $routes //rdbc:route [
    fn:matches($route, rdbc:pattern) 
    and rdbc:verb() = rdbc:verb ] [1]
return if ($selected)
       then
         let $pattern  := $selected//rdbc:pattern
         let $resource := $selected/rdbc:resource/@name
         let $redirect := fn:concat($resource, ".xqy")
         let $params   := fn:concat( "?", 
                            fn:string-join( for $p in $selected//rdbc:match
                              return 
                                let $resource := xdmp:url-encode(
                                  fn:analyze-string($route,$pattern)
                                    //s:group[@nr eq $p/@nr] )
                                return if ($resource)
                                       then fn:concat( fn:string($p), "=",
                                 $resource ) else () , "&amp;" ) )
         return fn:concat($redirect, $params)
       else
         "404.xqy"
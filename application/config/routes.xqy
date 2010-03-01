xquery version "1.0-ml";
module namespace routes = "http://ns.dscape.org/2010/rdbc/cfg/routes";

declare namespace rdbc="http://ns.dscape.org/2010/rdbc/core";

declare variable $routes :=
<rdbc:routes>
  <rdbc:route>
    <rdbc:pattern>^/(db(/)([\w|\-|_]+)/)?doc(/)([\w|\-|_|\.]+)$</rdbc:pattern>
    <rdbc:resource name="doc">
      <rdbc:match nr="3">db</rdbc:match>
      <rdbc:match nr="5">doc</rdbc:match>
    </rdbc:resource>
    <rdbc:verb>get</rdbc:verb>
    <rdbc:verb>put</rdbc:verb>
    <rdbc:verb>post</rdbc:verb>
    <rdbc:verb>delete</rdbc:verb>
  </rdbc:route>
<!--  <rdbc:route>
    <rdbc:pattern> ^/(db/[\w|\-|_]+/)?uris </rdbc:pattern>
    <rdbc:verbs> get </rdbc:verbs>
  </rdbc:route>
  <rdbc:route>
    <rdbc:pattern> ^/(db/[\w|\-|_]+/)?search/(.+) </rdbc:pattern>
    <rdbc:verbs> get </rdbc:verbs>
  </rdbc:route> -->
</rdbc:routes> ;

(:
 : Route File for RDBC
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

(: Method to access the configuration file :)
declare function routes:routes() { $routes } ;

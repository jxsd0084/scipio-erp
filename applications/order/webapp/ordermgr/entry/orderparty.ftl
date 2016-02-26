<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<#if security.hasEntityPermission("ORDERMGR", "_CREATE", session)>
  <@section title="${uiLabelMap.PartyParty}"> <#-- class="boxoutside" -->
      <@table type="fields" width="100%" class="+boxbottom"> <#-- orig: class="boxbottom" --> <#-- orig: cellspacing="0" --> <#-- orig: cellpadding="0" --> <#-- orig: border="0" -->
        <@tr>
          <@td align="center">
            <#if person?has_content>
              <div><a href="${customerDetailLink}${partyId}" class="${styles.link_nav_info_name!}">${person.firstName!}&nbsp;${person.lastName!}</a></div>
            <#elseif partyGroup?has_content>
                              <div class="tabletext"><a href="${customerDetailLink}${partyId}" class="${styles.link_nav_info_name!}">${partyGroup.groupName!}</a></div>
            </#if>
            <form method="post" action="<@ofbizUrl>orderentry</@ofbizUrl>" name="setpartyform">
              <div><input type="text" name="partyId" size="10" value="${partyId!}" /></div>
              <div>
                <a href="javascript:document.setpartyform.submit();" class="${styles.link_run_session!} ${styles.action_update!}">${uiLabelMap.CommonSet}</a>&nbsp;|&nbsp;<a href="<@ofbizInterWebappUrl>/partymgr/control/findparty</@ofbizInterWebappUrl>" class="${styles.link_nav!} ${styles.action_find!}">${uiLabelMap.CommonFind}</a><#if partyId?default("_NA_") != "_NA_" && partyId?default("_NA_") != "">&nbsp;|&nbsp;<a href="${customerDetailLink}${partyId}" class="${styles.link_nav!} ${styles.action_view!}">${uiLabelMap.CommonView}</a></#if>
              </div>
            </form>
          </@td>
        </@tr>
      </@table>
  </@section>
<#else>
  <@commonMsg type="error">${uiLabelMap.OrderViewPermissionError}</@commonMsg>
</#if>

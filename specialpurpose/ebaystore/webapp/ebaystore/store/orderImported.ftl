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
<@script>
function uploadTrackingCode(orderId, productStoreId) {
    document.uploadTracking.orderId.value = orderId;
    document.uploadTracking.productStoreId.value = productStoreId;
    document.uploadTracking.submit();
}
</@script>
<@section title="${uiLabelMap.EbayListOrderImported}">
  <form name="uploadTracking" action="<@ofbizUrl>uploadTrackingCodeBack</@ofbizUrl>" method="post">
      <input type="hidden" name="orderId" value=""/>
      <input type="hidden" name="productStoreId" value=""/>
  </form>
  <form name="listOrdersImported" method="post">
      <input type="hidden" name="viewSize"/>
      <input type="hidden" name="viewIndex"/>
      <@table type="data-list" autoAltRows=true class="+hover-bar" cellspacing="0"> <#-- orig: class="basic-table hover-bar" -->
       <@thead>
        <@tr class="header-row">
          <@th width="5%">${uiLabelMap.OrderOrderType}</@th>
          <@th width="5%">${uiLabelMap.OrderOrderId}</@th>
          <@th width="20%">${uiLabelMap.PartyName}</@th>
          <@th width="5%" align="right">${uiLabelMap.OrderSurvey}</@th>
          <@th width="5%" align="right">${uiLabelMap.OrderItemsOrdered}</@th>
          <@th width="5%" align="right">${uiLabelMap.OrderItemsBackOrdered}</@th>
          <@th width="5%" align="right">${uiLabelMap.OrderItemsReturned}</@th>
          <@th width="10%" align="right">${uiLabelMap.OrderRemainingSubTotal}</@th>
          <@th width="10%" align="right">${uiLabelMap.OrderOrderTotal}</@th>
          <@th width="5%">&nbsp;</@th>
            <#if (requestParameters.filterInventoryProblems?default("N") == "Y") || (requestParameters.filterPOsOpenPastTheirETA?default("N") == "Y") || (requestParameters.filterPOsWithRejectedItems?default("N") == "Y") || (requestParameters.filterPartiallyReceivedPOs?default("N") == "Y")>
              <@th width="15%">${uiLabelMap.CommonStatus}</@th>
              <@th width="5%">${uiLabelMap.CommonFilter}</@th>
            <#else>
              <@th width="20%">${uiLabelMap.CommonStatus}</@th>
            </#if>
          <@th width="20%">${uiLabelMap.CommonDate}</@th>
        </@tr>
       </@thead>
        <#if orderList?has_content>
          <#list orderList as orderHeader>
            <#assign orh = Static["org.ofbiz.order.order.OrderReadHelper"].getHelper(orderHeader)>
            <#assign statusItem = orderHeader.getRelatedOne("StatusItem", true)>
            <#assign orderType = orderHeader.getRelatedOne("OrderType", true)>
            <#if orderType.orderTypeId == "PURCHASE_ORDER">
              <#assign displayParty = orh.getSupplierAgent()!>
            <#else>
              <#assign displayParty = orh.getPlacingParty()!>
            </#if>
            <#assign partyId = displayParty.partyId?default("_NA_")>
            <@tr valign="middle">
              <@td>${orderType.get("description",locale)?default(orderType.orderTypeId?default(""))}</@td>
              <@td><a href="#" onclick="javascript:uploadTrackingCode('${orderHeader.orderId}','${productStoreId}')" class="${styles.link_nav_record_id!}">${orderHeader.orderId}</a></@td>
              <@td>
                  <#if displayParty?has_content>
                      <#assign displayPartyNameResult = dispatcher.runSync("getPartyNameForDate", Static["org.ofbiz.base.util.UtilMisc"].toMap("partyId", displayParty.partyId, "compareDate", orderHeader.orderDate, "userLogin", userLogin))/>
                      ${displayPartyNameResult.fullName?default("[${uiLabelMap.OrderPartyNameNotFound}]")}
                  <#else>
                    ${uiLabelMap.CommonNA}
                  </#if>
              </@td>
              <@td align="right">${orh.hasSurvey()?string.number}</@td>
              <@td align="right">${orh.getTotalOrderItemsQuantity()?string.number}</@td>
              <@td align="right">${orh.getOrderBackorderQuantity()?string.number}</@td>
              <@td align="right">${orh.getOrderReturnedQuantity()?string.number}</@td>
              <@td align="right"><@ofbizCurrency amount=orderHeader.remainingSubTotal isoCode=orh.getCurrency()/></@td>
              <@td align="right"><@ofbizCurrency amount=orderHeader.grandTotal isoCode=orh.getCurrency()/></@td>

              <@td>&nbsp;</@td>
              <@td>${statusItem.get("description",locale)?default(statusItem.statusId?default("N/A"))}</@td>

              <#if (requestParameters.filterInventoryProblems?default("N") == "Y") || (requestParameters.filterPOsOpenPastTheirETA?default("N") == "Y") || (requestParameters.filterPOsWithRejectedItems?default("N") == "Y") || (requestParameters.filterPartiallyReceivedPOs?default("N") == "Y")>
                  <@td>
                      <#if filterInventoryProblems.contains(orderHeader.orderId)>
                        Inv&nbsp;
                      </#if>
                      <#if filterPOsOpenPastTheirETA.contains(orderHeader.orderId)>
                        ETA&nbsp;
                      </#if>
                      <#if filterPOsWithRejectedItems.contains(orderHeader.orderId)>
                        Rej&nbsp;
                      </#if>
                      <#if filterPartiallyReceivedPOs.contains(orderHeader.orderId)>
                        Part&nbsp;
                      </#if>
                  </@td>
              </#if>
              <@td>${orderHeader.getString("orderDate")}</@td>
            </@tr>
          </#list>
        <#else>
          <@tr type="meta">
            <@td colspan='4'><@resultMsg>${uiLabelMap.EbayNoOrderImported}.</@resultMsg></@td>
          </@tr>
        </#if>
        <#if lookupErrorMessage??>
          <@tr type="meta">
            <@td colspan='4'><@resultMsg>${lookupErrorMessage}</@resultMsg></@td>
          </@tr>
        </#if>
      </@table>
  </form>
</@section>
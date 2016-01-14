<#-- TODO: License -->

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
function insertImageName(type,nameValue) {
  eval('document.productCategoryForm.' + type + 'ImageUrl.value=nameValue;');
};
</@script>

<#if fileType?has_content>
    <@section title="${uiLabelMap.ProductResultOfImageUpload}">
        <#if !(clientFileName?has_content)>
            <div>${uiLabelMap.ProductNoFileSpecifiedForUpload}.</div>
        <#else>
            <div>${uiLabelMap.ProductTheFileOnYourComputer}: <b>${clientFileName!}</b></div>
            <div>${uiLabelMap.ProductServerFileName}: <b>${fileNameToUse!}</b></div>
            <div>${uiLabelMap.ProductServerDirectory}: <b>${imageServerPath!}</b></div>
            <div>${uiLabelMap.ProductTheUrlOfYourUploadedFile}: <b><a href="<@ofbizContentUrl>${imageUrl!}</@ofbizContentUrl>" class="${styles.link_nav_uri!}">${imageUrl!}</a></b></div>
        </#if>
    </@section>
</#if>

<#if !productCategory?has_content>
    <#if productCategoryId?has_content>
        <#assign sectionTitle>${uiLabelMap.ProductCouldNotFindProductCategoryWithId} "${productCategoryId}".</#assign>
        <#assign formAction><@ofbizUrl>createProductCategory</@ofbizUrl></#assign>
    <#else>
        <#assign sectionTitle>${uiLabelMap.PageTitleCreateProductCategory}</#assign>
        <#assign formAction><@ofbizUrl>createProductCategory</@ofbizUrl></#assign>
    </#if>
<#else>
    <#assign sectionTitle>${uiLabelMap.PageTitleEditProductCategories}</#assign>
    <#assign formAction><@ofbizUrl>updateProductCategory</@ofbizUrl></#assign>
</#if>

<@section title=sectionTitle>

        <form action="${formAction}" method="post" name="productCategoryForm">
          <#if productCategory?has_content>
            <input type="hidden" name="productCategoryId" value="${productCategoryId}"/>
          </#if>
            <@row>
                <@cell columns=6>
                <#if !productCategory?has_content>
                  <#if productCategoryId?has_content>
                    <@field type="generic" label="${uiLabelMap.CommonId}">
                        <input type="text" name="productCategoryId" size="20" maxlength="40" value="${productCategoryId}"/>
                    </@field>
                  <#else>
                    <@field type="generic" label="${uiLabelMap.CommonId}">
                        <input type="text" name="productCategoryId" size="20" maxlength="40" value=""/>
                    </@field>
                  </#if>
                <#else>
                <@field type="generic" label="${uiLabelMap.CommonId}">
                    <b>${productCategoryId}</b>
                </@field>
                </#if>
                </@cell>
                <@cell columns=6>
                    <@field type="generic" label="${uiLabelMap.CommonType}">
                        <select name="productCategoryTypeId" size="1">
                            <#assign selectedKey = "">
                            <#list productCategoryTypes as productCategoryTypeData>
                                <#if requestParameters.productCategoryTypeId?has_content>
                                    <#assign selectedKey = requestParameters.productCategoryTypeId>
                                <#elseif (productCategory?has_content && productCategory.productCategoryTypeId! == productCategoryTypeData.productCategoryTypeId)>
                                    <#assign selectedKey = productCategory.productCategoryTypeId>
                                </#if>
                                <option <#if selectedKey == productCategoryTypeData.productCategoryTypeId!>selected="selected"</#if> value="${productCategoryTypeData.productCategoryTypeId}">${productCategoryTypeData.get("description",locale)}</option>
                            </#list>
                        </select>
                    </@field>
                </@cell>
            </@row>
            <@row>
                <@cell columns=6>
                <@field type="generic" label="${uiLabelMap.CommonName}">
                    <input type="text" value="${(productCategory.categoryName)!}" name="categoryName" size="60" maxlength="60"/>
                </@field>
                </@cell>
                <@cell columns=6>
                <@field type="generic" label="${uiLabelMap.CommonParent}">
                    <@htmlTemplate.lookupField value="${(productCategory.primaryParentCategoryId)?default('')}" formName="productCategoryForm" name="primaryParentCategoryId" id="primaryParentCategoryId" fieldFormName="LookupProductCategory"/>
                </@field>
                </@cell>
            </@row>
            <@row>
                <@cell columns=12>
                <@field type="generic" label="${uiLabelMap.CommonDescription}">
                    <textarea name="description" cols="60" rows="2"><#if productCategory?has_content>${(productCategory.description)!}</#if></textarea>
                </@field>
                </@cell>
            </@row>
            <@row>
                <@cell columns=6>
                <#assign labelDetail>
                    <#if (productCategory.categoryImageUrl)??>
                        <a href="<@ofbizContentUrl>${(productCategory.categoryImageUrl)!}</@ofbizContentUrl>" target="_blank"><img alt="Category Image" src="<@ofbizContentUrl>${(productCategory.categoryImageUrl)!}</@ofbizContentUrl>" class="cssImgSmall" /></a>
                    </#if>
                </#assign>
                <@field type="generic" label="${uiLabelMap.ProductCategoryImageUrl}" labelDetail=labelDetail>
                    <input type="text" name="categoryImageUrl" value="${(productCategory.categoryImageUrl)?default('')}" size="60" maxlength="255"/>
                        <#if productCategory?has_content>
                            <div>
                            ${uiLabelMap.ProductInsertDefaultImageUrl}:
                            <a href="javascript:insertImageName('category','${imageNameCategory}.jpg');" class="${styles.link_action!}">.jpg</a>
                            <a href="javascript:insertImageName('category','${imageNameCategory}.gif');" class="${styles.link_action!}">.gif</a>
                            <a href="javascript:insertImageName('category','');" class="${styles.link_action!}">${uiLabelMap.CommonClear}</a>
                            </div>
                        </#if>
                </@field>
                </@cell>
                <@cell columns=6>
                <#assign labelDetail>
                    <#if (productCategory.linkOneImageUrl)??>
                        <a href="<@ofbizContentUrl>${(productCategory.linkOneImageUrl)!}</@ofbizContentUrl>" target="_blank"><img alt="Link One Image" src="<@ofbizContentUrl>${(productCategory.linkOneImageUrl)!}</@ofbizContentUrl>" class="cssImgSmall" /></a>
                    </#if>
                </#assign>
                <@field type="generic" label="${uiLabelMap.ProductLinkOneImageUrl}" labelDetail=labelDetail>
                    <input type="text" name="linkOneImageUrl" value="${(productCategory.linkOneImageUrl)?default('')}" size="60" maxlength="255"/>
                        <#if productCategory?has_content>
                            <div>
                                ${uiLabelMap.ProductInsertDefaultImageUrl}:
                                <a href="javascript:insertImageName('linkOne','${imageNameLinkOne}.jpg');" class="${styles.link_action!}">.jpg</a>
                                <a href="javascript:insertImageName('linkOne','${imageNameLinkOne}.gif');" class="${styles.link_action!}">.gif</a>
                                <a href="javascript:insertImageName('linkOne','');" class="${styles.link_action!}">${uiLabelMap.CommonClear}</a>
                            </div>
                        </#if>
                </@field>
                </@cell>
            </@row>
            <@row>
                <@cell columns=6>
                <#assign labelDetail>
                    <#if (productCategory.linkTwoImageUrl)??>
                        <a href="<@ofbizContentUrl>${(productCategory.linkTwoImageUrl)!}</@ofbizContentUrl>" target="_blank"><img alt="Link One Image" src="<@ofbizContentUrl>${(productCategory.linkTwoImageUrl)!}</@ofbizContentUrl>" class="cssImgSmall" /></a>
                    </#if>
                </#assign>
                <@field type="generic" label="${uiLabelMap.ProductLinkTwoImageUrl}" labelDetail=labelDetail>
                    <input type="text" name="linkTwoImageUrl" value="${(productCategory.linkTwoImageUrl)?default('')}" size="60" maxlength="255"/>
                        <#if productCategory?has_content>
                            <div>
                                ${uiLabelMap.ProductInsertDefaultImageUrl}:
                                <a href="javascript:insertImageName('linkTwo','${imageNameLinkTwo}.jpg');" class="${styles.link_action!}">.jpg</a>
                                <a href="javascript:insertImageName('linkTwo','${imageNameLinkTwo}.gif');" class="${styles.link_action!}">.gif</a>
                                <a href="javascript:insertImageName('linkTwo','');" class="${styles.link_action!}">${uiLabelMap.CommonClear}</a>
                            </div>
                        </#if>
                </@field>
                </@cell>
                <@cell columns=6>
                <@field type="generic" label="${uiLabelMap.ProductDetailScreen}">
                    <input type="text" <#if productCategory?has_content>value="${productCategory.detailScreen!}"</#if> name="detailScreen" size="60" maxlength="250"/>
                        <br /><span class="tooltip">${uiLabelMap.ProductDefaultsTo} &quot;categorydetail&quot;, ${uiLabelMap.ProductDetailScreenMessage}: &quot;component://ecommerce/widget/CatalogScreens.xml#categorydetail&quot;</span>
                </@field>
                </@cell>
            </@row>
                <@field type="submitarea">
                    <input type="submit" name="Update" value="${uiLabelMap.CommonUpdate}"/>
                </@field>

        </form>
</@section>


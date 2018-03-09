<div class="advert">
	{%for category in categories%}
	<div class="category aditem resource">
		<div class="resourceid">{{contextroot}}/stores/{{storeid}}/category/{{category.catalogGroup.catalogGroupIdentifier.uniqueID}}</div>
		<a href="{{STORE_ROOT}}/category/{{category.catalogGroup.description.name|urlencode}}">
           	<img src="{{STORE_CONTEXT_ROOT}}/{{category.catalogGroup.description.thumbnail}}" 
               	alt="{{category.catalogGroup.description.shortDescription}}" border="0" />
	        <p class="name">{{category.catalogGroup.description.name}}</p>
			<p class="description">{{category.catalogGroup.description.shortDescription}}</p>
        </a>
        <div class="clickinfo">CpgnClick?mpe_id={{category.catalogGroup.catalogGroupIdentifier.uniqueID}}&amp;intv_id={{category.activityIdentifier.uniqueID}}{%for result in category.experimentResult%}&amp;experimentId={{result.experiment.uniqueID}}&amp;testElementId={{result.testElement.uniqueID}}&amp;expDataType={{category.dataType}}&amp;expDataUniqueID={{category.uniqueID}}{%endfor%}</div>
    </div>
	{%endfor%}

	{%for product in products%}
	<div class="product aditem resource">
		<div class="resourceid">{{contextroot}}/stores/{{storeid}}/product/{{product.data.catalogEntry.catalogEntryIdentifier.uniqueID}}</div>
		<a href="{{STORE_ROOT}}/product/{{product.data.catalogEntry.description.name|urlencode}}">
           	<img src="{{STORE_CONTEXT_ROOT}}/{{product.data.catalogEntry.description.thumbnail}}" 
               	alt="{{product.data.catalogEntry.description.shortDescription}}" border="0" />
    	    <p class="name">{{product.data.catalogEntry.description.name}}</p>
			<p class="description">{{product.data.catalogEntry.description.shortDescription}}</p>
			{%if product.listPrice%}   
	        <p class="listPrice">{{product.listPrice}}</p>
			{%endif%}
        	<p class="price bold">{{product.data.catalogEntry.price.standardPrice.price.price.value}}</p>    
        </a>
    	<div class="clickinfo">CpgnClick?mpe_id={{product.data.catalogEntry.catalogEntryIdentifier.uniqueID}}&amp;intv_id={{product.data.activityIdentifier.uniqueID}}{%for result in product.data.experimentResult%}&amp;experimentId={{result.experiment.uniqueID}}&amp;testElementId={{result.testElement.uniqueID}}&amp;expDataType={{product.data.dataType}}&amp;expDataUniqueID={{product.data.uniqueID}}{%endfor%}</div>
    </div>	
	{%endfor%}

	{%for content in mktgcontent%}
	<div class="marketingcontent aditem">
	{%if content.formatFile%}
	{% if content.mimeImage%}
		{%if content.url%}
		<a href="{{STORE_ROOT}}/{{content.url|urlencode}}" > 
		{%endif%}
		<img
			src="{{STORE_CONTEXT_ROOT}}/{{content.asset.attachmentAssetPath}}"
					alt="{{content.assetDescription.shortDescription}}"
					border="0"
		/>
		{%if content.url%}
			</a>
		{%endif%}
	 {%else%}
	 {%if content.mimeApp%}
	 	{%if content.attachMimeShockwave%}
		 <object data="{{STORE_CONTEXT_ROOT}}/{{content.asset.attachmentAssetPath}}"
              width="{%if adWidth%}{{adWidth}}{%else%}588{%endif%}"
              height="{%if adHeight%}{{adHeight}}{%else%}216{%endif%}"
              type="application/x-shockwave-flash">
              <param name="movie" value="{{STORE_CONTEXT_ROOT}}/{{asset.attachmentAssetPath}}"/>
              <param name="quality" value="high"/>
              <param name="bgcolor" value="#FFFFFF"/>
              <param name="pluginurl" value="http://www.macromedia.com/go/getflashplayer"/>
              <param name="wmode" value="opaque"/>
         </object>
     	{%endif%}
     	{%if content.attachMimeNotShockwave%}
 		 <a  href="{{STORE_CONTEXT_ROOT}}/{{content.asset.attachmentAssetPath}}" target="_blank">
              <img src="{{STORE_CONTEXT_ROOT}}/{{content.attachment.attachmentUsage.image}}"
              alt="{{content.assetDescription.shortDescription}}"
              border="0"  />
         </a>
     	{%endif%}
     	{%if content.data.marketingContent.url%}
		<a href="{{STORE_ROOT}}/marketing/{{content.data.marketingContent.url|urlencode}}" > 
		{%endif%}
		{{content.data.marketingContent.marketingContentDescription.marketingText}}
		{%if content.marketingContent.url%}
		</a>
		{%endif%}
	{%else%}
        <a href="{{STORE_CONTEXT_ROOT}}/{{content.asset.attachmentAssetPath}}" target="_new">
               {{STORE_CONTEXT_ROOT}}{{content.asset.attachmentAssetPath}}
        </a>
                        
        {%if content.data.marketingContent.url%}
		<a href="{{STORE_ROOT}}/marketing/{{content.data.marketingContent.url|urlencode}}" > 
		{%endif%}
		{{content.data.marketingContent.marketingContentDescription.marketingText}}
		{%if content.marketingContent.url%}
		</a>
		{%endif%}
	{%endif%}
	{%endif%}
	{%endif%}
	{%if content.typeText%}
	    {%if content.data.marketingContent.url%}
		<a href="{{STORE_ROOT}}/marketing/{{content.data.marketingContent.url|urlencode}}" > 
		{%endif%}
		{{content.data.marketingContent.marketingContentDescription.marketingText}}
		{%if content.marketingContent.url%}
		</a>
		{%endif%}
	{%endif%}
    <div class="clickinfo">CpgnClick?mpe_id={{content.data.marketingContent.marketingContentIdentifier.uniqueID}}&amp;intv_id={{content.data.activityIdentifier.uniqueID}}{%for result in content.data.experimentResult%}&amp;experimentId={{result.experiment.uniqueID}}&amp;testElementId={{result.testElement.uniqueID}}&amp;expDataType={{content.data.dataType}}&amp;expDataUniqueID={{content.data.uniqueID}}{%endfor%}</div>
    </div>
	{%endfor%}
</div>
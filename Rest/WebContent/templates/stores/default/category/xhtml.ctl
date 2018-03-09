<div class="resource">	
	<div class="resourceid">{{category.resourceid}}</div>
	<div class="description">{{category.description}}</div>	
	<ul class="categories">
	{% for c in category.categories%}	
		<li class="resource">
			<div class="resourceid">{{c.resourceid}}</div>
			<div class="description">{{c.description}}</div>
			<div class="shortdescription">{{c.shortdescription}}</div>
			<div class="description">{{c.description}}</div>
			<img src="{{STORE_ROOT}}/{{c.thumbnail}}"/>
			<a href="{{STORE_ROOT}}/store/{{storeid}}/category/{{c.name|urlencode}}">{{c.name}}</a>
			{%if c.subCategories%}
			<ul class="subCategories">
				{% for sc in c.subCategories%}
				<li class="resource">
					<div class="resourceid">{{contextroot}}/stores/{{storeid}}/category/{{sc.categoryId}}</div>
					<div class="description">{{sc.description.shortDescription}}</div>
					<a href="{{STORE_ROOT}}/store/{{storeid}}/category/{{sc.identifier|urlencode}}">{{sc.identifier}}</a>
				</li>
				{%endfor%}
			</ul>
			{%endif%}
		</li>
	{%endfor%}
	</ul>
</div>
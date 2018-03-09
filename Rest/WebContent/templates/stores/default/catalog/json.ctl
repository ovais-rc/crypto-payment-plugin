{
	 "description":"{{catalog.description.longDescription}}",
	 "keywords":"{%for c in catalog.topCategories%}{{c.identifier}}{%if forloop.last%}{%else%},{%endif%}{%endfor%}",
	 "topCategories":
	[
		{% for c in catalog.topCategories%}	
		
		{
			"resourceid":"{{contextroot}}/stores/{{storeid}}/category/{{c.categoryId}}",
			"description":"{{c.description.shortDescription}}",
			"href":"{{STORE_ROOT}}/store/{{storeid}}/category/{{c.identifier|urlencode}}","display":"{{c.identifier}}",
			"subCategories":
			[
				{% for sc in c.subCategories%}
				{
					"resourceid":"{{contextroot}}/stores/{{storeid}}/category/{{sc.categoryId}}",
					"description":"{{sc.description.shortDescription}}",
					"href":"{{STORE_ROOT}}/store/{{storeid}}/category/{{sc.identifier|urlencode}}","display":"{{sc.identifier}}"
				}
				{%if forloop.last%}{%else%},{%endif%}
				{%endfor%}
			]
		}
		{%if forloop.last%}{%else%},{%endif%}
		{%endfor%}
	]
}
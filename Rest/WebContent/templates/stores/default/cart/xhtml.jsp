<%--
 =================================================================
  Licensed Materials - Property of IBM

  WebSphere Commerce

  (C) Copyright IBM Corp. 2010, 2011 All Rights Reserved.

  US Government Users Restricted Rights - Use, duplication or
  disclosure restricted by GSA ADP Schedule Contract with
  IBM Corp.
 =================================================================
--%>
<div class="resource">	
	<div class="resourceid">{{cart.resourceid}}</div>
	<div class="description">{{cart.description}}</div>	
	<ul class="orderIds">
	{% for c in cart.orderId%}	
		<li class="resource">
			<div class="resourceid">{{c}}</div>
			</ul>
			{%endif%}
		</li>
	{%endfor%}
	</ul>

	<ul class="orderItemIds">
	{% for c in cart.orderItemId%}	
		<li class="resource">
			<div class="orderItemId">{{c}}</div>
		</li>
	{%endfor%}
	</ul>
	
</div>
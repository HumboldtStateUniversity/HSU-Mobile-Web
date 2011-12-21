{include file="findInclude:common/templates/header.tpl"}

{if $description}
<div id="search-text">
    <div id="search-text-inner">
  		<p>
    	{$description|escape}
  		</p>      	
  	</div><!-- search-text-inner -->
</div><!-- #search-text -->
{/if}
    <div id="content-start">
    	<div id="content-start-inner">
    	</div><!-- #content-start-inner -->
    </div><!-- #content-start -->
{include file="findInclude:common/templates/navlist.tpl" navlistItems=$contacts secondary=true accessKey=false}

{include file="findInclude:common/templates/footer.tpl"}

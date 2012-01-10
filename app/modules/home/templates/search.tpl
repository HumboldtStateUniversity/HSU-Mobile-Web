{include file="findInclude:common/templates/header.tpl" scalable=false}

{include file="findInclude:common/templates/search.tpl" emphasized=false}
  <div id="content-start">
	<div id="content-start-inner">
	</div><!-- #content-start-inner -->
  </div><!-- #content-start -->
  <div class="content-area">
  {foreach $federatedSearchModules as $federatedSearchModule}
  <h3 class="nonfocal">{$federatedSearchModule['title']}</h3>
  <div id="{$federatedSearchModule['elementId']}">
    {block name="searchResults"}
      <div class="focal">
        <div class="loading">Loading...</div>
      </div>
    {/block}
  </div>
{/foreach}
	</div><!-- .content-area -->
{include file="findInclude:common/templates/footer.tpl"}

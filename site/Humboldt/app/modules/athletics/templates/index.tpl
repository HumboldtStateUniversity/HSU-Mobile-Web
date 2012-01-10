{include file="findInclude:common/templates/header.tpl" scalable=false}
{* {include file="findInclude:common/templates/search.tpl"} *}
	<div id="content-start">
		<div id="content-start-inner">
		</div><!-- #content-start-inner -->
	</div><!-- #content-start -->
<div class="content-area">
{$tabBodies = array()}

{if $topNews}
  {capture name="topnewsTab" assign="topnewsTab"}
     
    {include file="findInclude:modules/athletics/templates/stories.tpl" stories=$topNews}  
  {/capture}
  {$tabBodies[$topNewsTitle] = $topnewsTab}
{/if}

{if $menSports}
  {capture name="menTab" assign="menTab"}
    {include file="findInclude:common/templates/navlist.tpl" navlistItems=$menSports}
  {/capture}
  {$tabBodies[$menSportsTitle] = $menTab}
{/if}

{if $womenSports}
  {capture name="womenTab" assign="womenTab"}
    {include file="findInclude:common/templates/navlist.tpl" navlistItems=$womenSports}
  {/capture}
  {$tabBodies[$womenSportsTitle] = $womenTab}
{/if}

{if $bookmarksTitle} 
  {capture name="bookmarksTab" assign="bookmarksTab"}
    {include file="findInclude:modules/athletics/templates/bookmarks.tpl"}
  {/capture}
  {$tabBodies[$bookmarksTitle] = $bookmarksTab}
{/if}

<div id="tabscontainer">
{include file="findInclude:common/templates/tabs.tpl" tabBodies=$tabBodies smallTabs=true}
</div>
</div><!-- .content-area -->
{include file="findInclude:common/templates/footer.tpl"}

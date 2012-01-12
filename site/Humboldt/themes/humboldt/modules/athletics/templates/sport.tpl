{include file="findInclude:common/templates/header.tpl"}
<div id="content-start">
    <div id="content-start-inner">
    </div><!-- #content-start-inner -->
</div><!-- #content-start -->

<div class="topsection">
<h1 class="nonfocal">{$sportTitle}</h1>
{include file="findInclude:common/templates/bookmark.tpl" name=$cookieName item=$bookmarkItem exdate=$expireDate}  

{if $scheduleItems}
<h2 class="nonfocal section">{"SCHEDULE_TITLE"|getLocalizedString}</h2>
{include file="findInclude:common/templates/navlist.tpl" navlistItems=$scheduleItems subTitleNewline=true}
{/if}
{if $newsItems}
    <h2 class="nonfocal section">{"NEWS_TITLE"|getLocalizedString}</h2>
    {include file="findInclude:modules/athletics/templates/stories.tpl" stories=$newsItems} 
{/if}
</div>


{include file="findInclude:common/templates/footer.tpl"}

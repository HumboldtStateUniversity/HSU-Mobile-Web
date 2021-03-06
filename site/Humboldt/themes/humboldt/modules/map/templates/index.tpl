{include file="findInclude:common/templates/header.tpl" scalable=false}

{include file="findInclude:common/templates/search.tpl"}

{if $browseHint}
<div class="nonfocal">
  <h3>{$browseHint}</h3>
</div>
{/if}

{if $bookmarkStatus}
{include file="findInclude:common/templates/bookmark.tpl" name=$cookieName item=$bookmarkItem exdate=$expireDate}
{/if}

{if $hasBookmarks}
{include file="findInclude:common/templates/navlist.tpl" navlistItems=$bookmarkLink secondary=true}
{/if}

{include file="findInclude:common/templates/navlist.tpl" navlistItems=$categories navlistID="categories"}

{if $clearLink}
{include file="findInclude:common/templates/navlist.tpl" navlistItems=$clearLink secondary=true}
{/if}

{include file="findInclude:common/templates/footer.tpl"}

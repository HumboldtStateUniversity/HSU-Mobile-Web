{include file="findInclude:common/templates/header.tpl" scalable=false}

{block name="programsHeader"}
  {include file="findInclude:common/templates/search.tpl" extraArgs=$extraArgs}
{/block}

{if count($stories)}
  {block name="stories"}
    {include file="findInclude:modules/programs/templates/stories.tpl"}
  {/block}
{else}
  <div class="nonfocal">
    {"NO_RESULTS"|getLocalizedString}
  </div>
{/if}

{include file="findInclude:common/templates/footer.tpl"}

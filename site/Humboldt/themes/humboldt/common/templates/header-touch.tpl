{extends file="findExtends:common/templates/header.tpl"}

{block name="javascript"}{/block}
{block name="onLoad"}{/block}



{block name="navbar"}
  <div id="navbar"{if $hasHelp} class="helpon"{/if}>
    <div class="breadcrumbs{if $isModuleHome} homepage{/if}">
      <a name="top" href="{$homeLink}" class="homelink">
        <img src="/common/images/homelink.gif" width="{$homelink_image_width|default:40}" height="{$homelink_image_height|default:30}" alt="{$homeLinkText}" />
      </a>
      {$breadcrumbHTML}
        
      <span class="pagetitle">
        {$pageTitle|sanitize_html:'inline'}
      </span>
    </div>
  </div>
{/block}

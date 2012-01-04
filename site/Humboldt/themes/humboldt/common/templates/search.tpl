{capture name="hiddenArgHTML" assign="hiddenArgHTML"}
  {if (!isset($searchPage) && ($page == 'search')) || ($page == $searchPage)}
    {$hiddenArgs = $breadcrumbSamePageArgs}
  {else}
    {$hiddenArgs = $breadcrumbArgs}
  {/if}
  
  {if isset($extraArgs)}
    {$hiddenArgs = array_merge($extraArgs, $hiddenArgs)}
  {/if}
  {foreach $hiddenArgs as $arg => $value}
    <input type="hidden" name="{$arg}" value="{$value}" />
  {/foreach}
{/capture}

{capture name="inlineErrorHTML" assign="inlineErrorHTML"}
  {if $inlineSearchError}
    <p>{$inlineSearchError}</p>
  {elseif isset($resultCount)}
    {if $resultCount == 0}
      <p>No matches found</p>
    {else}
      <p>{$resultCount} match{if $resultCount != 1}es{/if} found</p>
    {/if}
  {/if}
{/capture}

{capture name="tipHTML" assign="tipHTML"}
  {if isset($tip)}
    <p class="legend nonfocal">
      <strong>Search tip:</strong> {$tip}
    </p>
  {/if}
{/capture}

{block name="form"}
    {if $moduleID == 'people'}
    <div id="search-text">
    	<div id="search-text-inner">
      	<p>Enter a person's name, department, email address , telephone number, location, or title.</p>
      	</div><!-- search-text-inner -->
	</div><!-- #search-text -->
	{/if}
    <div class="nonfocal" id="searchformcontainer">
      <div class="searchwrapper">
      <form method="get" action="{$searchPage|default:'search'}">
        <fieldset class="inputcombo{if $emphasized|default:$isModuleHome} emphasized{/if}">
          	<input class="forminput" type="text" id="{$inputName|default:'filter'}" name="{$inputName|default:'filter'}" placeholder="{$placeholder|default:''}" value="{$searchTerms|escape}" onfocus="androidPlaceholderFix(this);" />
          <input class="combobutton" id="sch_btn" src="/common/images/search-button.png" type="image" />
          {$hiddenArgHTML}
        </fieldset>
        {if isset($additionalInputs)}
		<div style="height: 40px; margin: 20px 0; clear: both;">
        	<fieldset>
            	{$additionalInputs}
        	</fieldset>
        </div>
        {/if}
      </form>
      </div>
	</div>
	{if $moduleID != 'home'}	
	<div id="content-start">
		<div id="content-start-inner">
		</div><!-- #content-start-inner -->
	</div><!-- #content-start -->
	<div class="content-area">
        {$inlineErrorHTML}
	</div><!-- .content-area -->
	{/if}
{/block}

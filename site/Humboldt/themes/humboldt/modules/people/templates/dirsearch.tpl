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

{block name="form"}
    <div id="search-text">
    	<div id="search-text-inner">
      	<p>Enter a person's name, department, email address , telephone number, location, or title.</p>
      	</div>	
	</div><!-- #search-text -->
    <div class="nonfocal" id="searchformcontainer">
      <form method="get" action="{$searchPage|default:'search'}">
        
        <fieldset class="inputcombo{if $emphasized|default:$isModuleHome} emphasized{/if}">
          <div class="searchwrapper">
          	<input class="forminput" type="text" id="{$inputName|default:'filter'}" name="{$inputName|default:'filter'}" placeholder="{$placeholder|default:''}" value="{$searchTerms|escape}" onfocus="androidPlaceholderFix(this);" />
          </div>

          <input class="combobutton" id="sch_btn" src="/common/images/search-button.png" type="image" />
          {$hiddenArgHTML}
        </fieldset>
        {if isset($additionalInputs)}
          <fieldset>
            {$additionalInputs}
          </fieldset>
        {/if}
        {$inlineErrorHTML}
      
  {if !$insideForm}
      </form>
    </div>
    <div id="content-start">
    	<div id="content-start-inner">
    		stuffz
    	</div>    
    </div><!-- #content-start -->
  {/if}
{/block}

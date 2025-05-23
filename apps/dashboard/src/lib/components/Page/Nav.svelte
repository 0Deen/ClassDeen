<script>
  import { t } from '$lib/utils/functions/translations';
  import Chip from '../Chip/index.svelte';
  import TextField from '../Form/TextField.svelte';

  export let title = '';
  export let overidableStyle = '';
  export let navItems = [];
  export let disableSticky = false;
  export let isTitleEditable = false;
  export let onEditComplete = () => {};
  export let paddingClass = 'px-2';
  export let hideOnMobile = false;

  let dynamicRootClass = '';
  let enterEditTitleMode = false;

  $: dynamicRootClass = Array.isArray(navItems) && navItems.length > 4 ? 'bring-down' : '';
</script>

<div
  class="{hideOnMobile &&
    'hideOnMobile'} header border-b border-gray-200 bg-white dark:border-neutral-600 dark:bg-black {!disableSticky &&
    'sticky'} {dynamicRootClass}"
  style={overidableStyle}
>
  <div
    class="{hideOnMobile
      ? 'hidden lg:flex'
      : ''} {paddingClass} m-auto flex min-h-[61px] max-w-4xl items-center justify-between"
  >
    {#if !!title}
      {#if isTitleEditable}
        {#if !enterEditTitleMode}
          <button class="w-full" on:click={() => (enterEditTitleMode = true)}>
            <h4
              class="editable-title overflow-ellipsis rounded-md px-3 hover:bg-gray-100 dark:bg-black"
            >
              {title}
            </h4>
          </button>
        {:else}
          <TextField
            bind:value={title}
            placeholder={$t('course.navItem.settings.course_title')}
            onChange={() => {
              enterEditTitleMode = false;

              if (typeof onEditComplete === 'function') {
                onEditComplete();
              }
            }}
          />
        {/if}
      {:else}
        <div class="flex w-full items-center" {title}>
          <slot name="image" />
          <h4
            class="{$$slots.image
              ? 'ml-2'
              : ''} truncate whitespace-nowrap text-lg font-semibold dark:text-white"
          >
            {title}
          </h4>
        </div>
      {/if}
    {/if}
    {#if Array.isArray(navItems) && navItems.length}
      <div class="flex items-center justify-evenly">
        {#each navItems as item}
          <a
            class="relative mr-5 flex items-center pb-2 text-sm font-bold {item.isActive
              ? 'text-primary-700'
              : 'text-black dark:text-white'} hover:no-underline"
            href={item.href}
          >
            {item.label}

            {#if typeof item.badgeValue === 'number'}
              <Chip value={item.badgeValue} className="ml-1 bg-gray-300 dark:text-black" />
            {/if}
            <span
              class="bg-primary-700 absolute bottom-0 left-0 h-1 transition-all duration-500 ease-in-out {item.isActive
                ? 'w-full'
                : 'w-0'}"
            />
          </a>
        {/each}
      </div>
    {/if}
    <slot name="widget" />
  </div>
</div>

<style>
  .header {
    min-height: 61px;
    z-index: 1;
  }

  .header.sticky {
    position: sticky;
    top: 0;
  }

  .header.bring-down {
    flex-direction: column;
    align-items: flex-start;
  }

  .editable-title {
    font-size: 16px;
    display: flex;
    /* justify-content: center; */
    align-items: center;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    padding: 10px;
  }

  @media (max-width: 1024px) {
    .title {
      width: fit-content;
    }

    .hideOnMobile {
      display: none;
    }
  }
</style>

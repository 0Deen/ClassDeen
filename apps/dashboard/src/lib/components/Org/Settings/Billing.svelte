<script>
  import { VARIANTS } from '$lib/components/PrimaryButton/constants';
  import PrimaryButton from '$lib/components/PrimaryButton/index.svelte';
  import { snackbar } from '$lib/components/Snackbar/store';
  import { t } from '$lib/utils/functions/translations';
  import { currentOrgPlan, isFreePlan } from '$lib/utils/store/org';
  import { Column, Grid, Row } from 'carbon-components-svelte';
  import SectionTitle from '../SectionTitle.svelte';

  let isRedirecting = false;

  async function onOpenBilling() {
    console.log({
      plan: $currentOrgPlan
    });

    try {
      if ($currentOrgPlan?.provider === 'polar') {
        const url = new URL('/api/polar/portal', window.location.origin);
        url.searchParams.set('customerId', $currentOrgPlan?.customerId);

        window.open(url.toString(), '_blank');
      }

      if ($currentOrgPlan?.provider === 'lmz') {
        isRedirecting = true;
        const url = new URL('/api/lmz/subscription', window.location.origin);
        url.searchParams.set('subscriptionId', $currentOrgPlan?.subscriptionId);

        const response = await fetch(url.toString());
        const result = await response.json();

        isRedirecting = false;

        window.open(result.customerPortal, '_blank');
      }
    } catch (error) {
      isRedirecting = false;

      console.error(error);
      snackbar.error($t('settings.billing.error'));
    }
  }
</script>

<Grid class="border-c mt-5 w-full rounded border-gray-200 dark:border-neutral-600">
  <Row class="border-bottom-c flex flex-col py-7 lg:flex-row">
    <Column sm={4} md={4} lg={4}
      ><SectionTitle>{$t('settings.billing.sub_title')}</SectionTitle></Column
    >
    <Column sm={8} md={8} lg={8}>
      <h4 class="dark:text-white lg:mt-0">{$t('settings.billing.manage')}</h4>
      {#if $isFreePlan}
        {$t('settings.billing.active')}
      {:else}
        <p class="mb-3">{$t('settings.billing.provider')}</p>

        <PrimaryButton
          label={$t('settings.billing.open_billing')}
          variant={VARIANTS.CONTAINED_DARK}
          onClick={onOpenBilling}
          isLoading={isRedirecting}
        />
      {/if}
    </Column>
  </Row>
</Grid>

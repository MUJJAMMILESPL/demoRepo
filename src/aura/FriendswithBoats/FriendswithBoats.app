<aura:application extends="force:slds">
    <lightning:card title="Friends with Boats" class="seperatre-cards" variant="narrow"/>
    <div>
        <lightning:layout horizontalAlign="spread">
            <lightning:layoutItem flexibility="grow"
                                  class="slds-m-right_small">
                <c:BoatSearch />
            </lightning:layoutItem>
            <lightning:layoutItem size="{! $Browser.isDesktop ? '4' : '6' }"
                                  class="slds-m-left_small">
                right
            </lightning:layoutItem>
        </lightning:layout>
    </div>
</aura:application>
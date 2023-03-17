<aura:application   implements="lightning:isUrlAddressable,flexipage:availableForAllPageTypes" extends="force:slds">
   <aura:attribute name="claimIds" type="string" />
    <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
    <aura:attribute name="pageReferenceobj" type="object" />
    <c:ACETLGT_ClaimDetail_History claimIds="{!v.claimIds}" aura:id="historycmp"/>
  <!--<c:ACETLGT_ClaimDetail_History pageReferenceobj="{!v.pageReferenceobj}" aura:id="historycmp"	/>-->
</aura:application>
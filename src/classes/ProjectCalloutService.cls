public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='Sync project Data' description='Syncs Opportunity data with PMS')
    public static void postOpportunityToPMS(List<Id> projectOpportunityIds){
        System.enqueueJob(new ProjectCalloutService.QueueablePMSCall(projectOpportunityIds[0]));
    }

    public class QueueablePMSCall implements System.Queueable, Database.AllowsCallouts {

        Opportunity projectOpp;

        public QueueablePMSCall(Id projectOppId) {
            List<Opportunity> projectOpps = [
                SELECT
                    Id,
                    Name,
                    Account.Name,
                    CloseDate,
                    Amount
                FROM Opportunity
                WHERE Id = :projectOppId
            ];
            if(projectOpps.isEmpty() == false) {
                this.projectOpp = projectOpps[0];
            }
        }

        public void execute(QueueableContext context) {
            ServiceTokens__c token = ServiceTokens__c.getAll().get('ProjectServiceToken');
            if(projectOpp <> null && token <> null) {
                Map<String,Object> requestData = new Map<String,Object>();

                requestData.put('amount', Integer.valueOf(projectOpp.Amount));
                requestData.put('closeDate', projectOpp.CloseDate);
                requestData.put('accountName', projectOpp.Account.Name);
                requestData.put('opportunityName', projectOpp.Name);
                requestData.put('opportunityId', projectOpp.Id);

                String reqBodyData = JSON.serializePretty(requestData);
                SYstem.debug('\n\n reqBodyData : '+reqBodyData);

                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:ProjectService');
                req.setMethod('POST');
                req.setBody(reqBodyData);
                req.setHeader('token', token.Token__c);
                req.setHeader('Content-Type', 'application/json;charset=UTF-8');
                HttpResponse resp = h.send(req);
                system.debug('\n\n resp : '+resp);
                system.debug('\n\n resp getStatusCode : '+resp.getStatusCode());
                system.debug('\n\n resp body : '+resp.getBody());
                if(resp.getStatusCode() == 201) {
                    projectOpp.StageName = 'Submitted Project';
                } else {
                    projectOpp.StageName = 'Resubmit Project';
                }
                update projectOpp;
            }

        }
    }
}
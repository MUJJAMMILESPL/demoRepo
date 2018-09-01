public class BillingCalloutServiceMockFailure implements WebServiceMock {
   //Implement http mock callout here
    public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        System.assertEquals(requestName, 'billProjectRequest');
        BillingServiceProxy.billProjectResponse_element responseElement = new BillingServiceProxy.billProjectResponse_element();
        responseElement.status = 'failure';
        response.put('response_x', responseElement);
    }
}
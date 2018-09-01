@isTest
public class WarehouseSyncScheduleTest {
	@IsTest
    public static void testSchedule() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        	Id cronId = System.schedule(
                'ScheduleEquipmentSync ' + System.now(),
                '0 0 1 1/1 * ? *',
                new WarehouseSyncSchedule()
            );
        Test.stopTest();
        System.assertNotEquals(null, cronId, 'Job is not scheduled');
    }
}
@RestResource(urlMapping='/flowwolf/alliance/quotes/*')
global with sharing class XmlFileGenaration {

    @HttpPost
    global static void genarateAllianceQuotes() {
        String requestURI = RestContext.request.requestURI;
        String[] parts = requestURI.split('/');
        String loadId = parts.isEmpty() ? null : parts[parts.size() - 1];

        if (String.isEmpty(loadId) || loadId == 'xmlFile') {
            sendXmlResponse(createErrorMessage('LoadId is missing'));
            return;
        }

        // Start XML
        Dom.Document doc = new Dom.Document();
        Dom.XmlNode root = doc.createRootElement('RateResults', null, null);

        // Static XML parts
        root.addChildElement('LoglinkQuoteNumber', null, null).addTextNode('MVP9999912123');
        root.addChildElement('StatusCode', null, null).addTextNode('0');
        root.addChildElement('StatusMessage', null, null).addTextNode('Rating process completed without errors.');

        // Dynamic Part: PriceSheets
        Dom.XmlNode priceSheets = root.addChildElement('PriceSheets', null, null);

        for (Integer i = 0; i < 3; i++) {
            Dom.XmlNode priceSheet = priceSheets.addChildElement('PriceSheet', null, null);
            priceSheet.setAttribute('type', 'Cost');
            priceSheet.setAttribute('chargeModel', 'NORMALIZED_SMC');
            priceSheet.setAttribute('isSelected', 'false');
            priceSheet.setAttribute('isAllocated', 'false');
            priceSheet.setAttribute('currencyCode', 'USD');
            priceSheet.setAttribute('createDate', '04-08-2025 23:39:04');
            priceSheet.setAttribute('internalId', '');
        
            priceSheet.addChildElement('AccessorialTotal', null, null).addTextNode('316.57');
            priceSheet.addChildElement('LoglinkQuoteNumber', null, null).addTextNode('490022');
            priceSheet.addChildElement('SubTotal', null, null).addTextNode('694.43');
            priceSheet.addChildElement('Total', null, null).addTextNode('1221.06');
            
            Dom.XmlNode normTotal = priceSheet.addChildElement('NormalizedTotal', null, null);
            normTotal.setAttribute('currencyCode', 'USD');
            normTotal.addTextNode('1221.06');
        
            priceSheet.addChildElement('ContractId', null, null).addTextNode('490022');
            priceSheet.addChildElement('ContractName', null, null).addTextNode('XPO Logistics');
            priceSheet.addChildElement('CarrierId', null, null).addTextNode('001Ho00001EoGn9IAF');
            priceSheet.addChildElement('CarrierName', null, null).addTextNode('XPO Logistics');
            priceSheet.addChildElement('SCAC', null, null).addTextNode('XPOL');
            priceSheet.addChildElement('Mode', null, null).addTextNode('LTL');
            priceSheet.addChildElement('Service', null, null).addTextNode('P44_STD');
            priceSheet.addChildElement('ServiceDays', null, null).addTextNode('');
            priceSheet.addChildElement('Distance', null, null).addTextNode('0.0');
            priceSheet.addChildElement('Id', null, null).addTextNode('490022');
        
            // InsuranceTypes
            Dom.XmlNode insuranceTypes = priceSheet.addChildElement('InsuranceTypes', null, null);
        
            Dom.XmlNode ins1 = insuranceTypes.addChildElement('Insurance', null, null);
            ins1.setAttribute('type', 'Cargo');
            ins1.setAttribute('amount', '0.00');
            ins1.setAttribute('company', '');
            ins1.setAttribute('expirationDate', '');
            ins1.setAttribute('contactName', '');
            ins1.setAttribute('contactPhone', '');
        
            Dom.XmlNode ins2 = insuranceTypes.addChildElement('Insurance', null, null);
            ins2.setAttribute('type', 'General');
            ins2.setAttribute('amount', '50000.00');
            ins2.setAttribute('company', 'Ace American Insurance Company');
            ins2.setAttribute('expirationDate', '03/01/2023 03:00');
            ins2.setAttribute('contactName', 'Aon Risk Services Southwest, Inc.');
            ins2.setAttribute('contactPhone', '8005418605');
        
            Dom.XmlNode ins3 = insuranceTypes.addChildElement('Insurance', null, null);
            ins3.setAttribute('type', 'Liability');
            ins3.setAttribute('amount', '2000000.00');
            ins3.setAttribute('company', 'Ace American Insurance Company');
            ins3.setAttribute('expirationDate', '03/01/2023 03:00');
            ins3.setAttribute('contactName', 'Aon Risk Services Southwest, Inc.');
            ins3.setAttribute('contactPhone', '8005418605');
        
            // Address
            Dom.XmlNode address = priceSheet.addChildElement('Address', null, null);
            address.setAttribute('type', 'Preferred Carrier');
            address.setAttribute('isResidential', 'false');
            address.setAttribute('isPrimary', 'false');
            
            address.addChildElement('LocationCode', null, null).addTextNode('');
            address.addChildElement('Alias', null, null).addTextNode('');
            address.addChildElement('Name', null, null).addTextNode('XPO Logistics');
            address.addChildElement('AddrLine1', null, null).addTextNode('');
            address.addChildElement('AddrLine2', null, null).addTextNode('');
            address.addChildElement('City', null, null).addTextNode('');
            address.addChildElement('StateProvince', null, null).addTextNode('');
            address.addChildElement('PostalCode', null, null).addTextNode('');
            address.addChildElement('CountryCode', null, null).addTextNode('US');
        
            Dom.XmlNode geoLoc = address.addChildElement('GeoLoc', null, null);
            geoLoc.setAttribute('latDegrees', '');
            geoLoc.setAttribute('latDirection', '');
            geoLoc.setAttribute('longDegrees', '');
            geoLoc.setAttribute('longDirection', '');
        
            address.addChildElement('Contacts', null, null).addTextNode('');
            address.addChildElement('Comments', null, null).addTextNode('');
        
            // Other tags
            priceSheet.addChildElement('ReasonCode', null, null).addTextNode('');
            priceSheet.addChildElement('Status', null, null).addTextNode('');
            priceSheet.addChildElement('LaneID', null, null).addTextNode('');
            priceSheet.addChildElement('Zone', null, null).addTextNode('');
            priceSheet.addChildElement('RouteGuidePriority', null, null).addTextNode('');
            priceSheet.addChildElement('CarrierLocationOid', null, null).addTextNode('');
            priceSheet.addChildElement('OriginService', null, null).addTextNode('');
            priceSheet.addChildElement('DestinationService', null, null).addTextNode('');
        
            // Charges node
            Dom.XmlNode charges = priceSheet.addChildElement('Charges', null, null);

            // Loop to add the same Charge node multiple times
            for (Integer j = 1; j <= 3; j++) {
                Dom.XmlNode charge = charges.addChildElement('Charge', null, null);
                charge.setAttribute('sequenceNum', String.valueOf(j));
                charge.setAttribute('type', 'Net Freight Charges');
                charge.setAttribute('itemGroupId', '');

                charge.addChildElement('Description', null, null).addTextNode('Net Freight Charges');
                charge.addChildElement('EdiCode', null, null);
                charge.addChildElement('Amount', null, null).addTextNode('694.43');
                charge.addChildElement('Rate', null, null).addTextNode('0.0');
                charge.addChildElement('RateQualifier', null, null).addTextNode('Fixed Cost');
                charge.addChildElement('Quantity', null, null).addTextNode('1.0');
                charge.addChildElement('Weight', null, null).addTextNode('0.0');
                charge.addChildElement('DimWeight', null, null).addTextNode('0.0');
                charge.addChildElement('FreightClass', null, null).addTextNode('0.0');
                charge.addChildElement('FakFreightClass', null, null).addTextNode('0.0');
                charge.addChildElement('IsMin', null, null).addTextNode('false');
                charge.addChildElement('IsMax', null, null).addTextNode('false');
                charge.addChildElement('IsNontaxable', null, null).addTextNode('false');
            }

            // Comments
            priceSheet.addChildElement('Comments', null, null).addTextNode('');
        }       
        
        sendXmlResponse(doc.toXmlString());
    }

    private static String createErrorMessage(String msg) {
        Dom.Document errorDoc = new Dom.Document();
        Dom.XmlNode root = errorDoc.createRootElement('error', null, null);
        root.addTextNode(msg);
        return errorDoc.toXmlString();
    }

    private static void sendXmlResponse(String xmlContent) {
        RestContext.response.addHeader('Content-Type', 'application/xml');
        RestContext.response.responseBody = Blob.valueOf(prettyFormatXml(xmlContent));
    }

    private static String prettyFormatXml(String rawXml) {
        rawXml = rawXml.replaceAll('><', '>\n<');
        List<String> lines = rawXml.split('\n');
        String result = '';
        Integer indentLevel = 0;

        for (String line : lines) {
            if (line.startsWith('</')) {
                indentLevel--;
            }

            result += String.valueOf('  '.repeat(Math.max(0, indentLevel))) + line + '\n';

            if (line.startsWith('<') && !line.startsWith('</') && !line.endsWith('/>') && !line.contains('</')) {
                indentLevel++;
            }
        }
        return result;
    }
}

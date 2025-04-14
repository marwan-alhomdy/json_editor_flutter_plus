import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:json_editor_flutter_plus/constants/enum.dart';
import 'package:json_editor_flutter_plus/json_editor_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'JSON Editor Example',
      home: JsonEditorExample(),
    );
  }
}

class JsonEditorExample extends StatelessWidget {
  const JsonEditorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('JSON Editor Example'),
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: JsonEditor(
          onChanged: (value) => {},
          themeColor: Colors.orange,
          hideEditorsMenuButton: false,
          enableHorizontalScroll: true,
          editors: const [Editors.text, Editors.tree],
          json: jsonEncode(json),
          onSave: (value) {
            log(value.toString());
          },
        ),
      ),
    );
  }
}

Map<String, dynamic> json = {
  "RoutesID": "68A84",
  "Description": "test route",
  "IsActive": true,
  "CityID": "CY003",
  "AreaID": "AR001",
  "BranchID": "3",
  "createdAt": "2025-02-07T18:32:52.016Z",
  "updatedAt": "2025-03-23T07:40:11.653Z",
  "MD_Staff": [
    {
      "StaffID": "SF0023",
      "StaffNameEN": "Staff Test",
      "StaffNameAR": "مندوب تجريبي للاضافه"
    },
    {
      "StaffID": "SH-3254",
      "StaffNameEN": "Awis Sajid",
      "StaffNameAR": "Awis Sajid"
    }
  ],
  "MD_CustomerRoutes": [
    {
      "customer": {
        "profile": {
          "CustomerID": "C009",
          "CustomerType": "Customer",
          "CustomerNameAR": "customer test",
          "CustomerNameEN": "customer test",
          "TradeName": "customer test",
          "BranchID": "3",
          "SubRangeID": "SR001",
          "PriceID": "PR001",
          "TaxID": "TX001",
          "MaxOrderValue": "10000",
          "TargetVisit": 10,
          "TargetValue": "10",
          "MasterCreditLimit": "10000",
          "IndividualCreditLimit": "1000",
          "Balance": "1500.75",
          "OpenOrder": 10,
          "OpenInvoice": 10,
          "StopSales": true,
          "IsActive": true,
          "SatffID": null,
          "CustomerTypeID": "CT001",
          "CategoryID": "CC001",
          "ClassID": "Cl001",
          "GroupID": "CG001",
          "AddressAR": "Saudi",
          "AddressEN": "Saudi",
          "PaymentTermID": "PT001",
          "AllowCash": true,
          "AllowCredit": true,
          "AllowBankTransfer": true,
          "AllowOverDraft": true,
          "AllowCheck": true,
          "AllowEPayment": null,
          "PhoneNo": "+966563214569",
          "MobileNo": "+966563214569",
          "WhatsappNo": "+966563214569",
          "E_mail": "customertest@gmail.com",
          "UserID": "9",
          "TokenID": "6267ebe3-7e07-45f1-8f24-0e280450fc68",
          "CountryID": "KSA",
          "Remarks": null,
          "StateID": "ST001",
          "RegionID": "R001",
          "CityID": "CT001",
          "AreaID": "AR001",
          "PostalZone": 58845,
          "BuildingNo": 3,
          "IsB2B": true,
          "VatRegistrationNo": "88454554554456460",
          "Taxpayer": null,
          "VatTypeID": "CRN",
          "VatValues": "15",
          "EGSCode": "52252",
          "ZatcaUsername": "customertest",
          "ZatcaPassoword": "1234567890",
          "Longitude": 46.6981,
          "Latitude": 24.9578,
          "RoutesID": "68A84",
          "IsParent": true,
          "ParentCustomerID": "0",
          "UseParentCreditLimit": false,
          "CreatedOn": "2025-03-08T08:15:27.186Z",
          "ModifiedOn": "2025-03-08T08:15:27.186Z",
          "ConfigSource": 456321789,
          "CashAccount": "456321789",
          "CheckAccount": "456321789",
          "BankTransferAccount": "456321789",
          "CreditCardAccount": "456321789",
          "OverdraftAccount": "456321789",
          "E_PaymentAccount": "456321789",
          "CashPaymentUnderCollection": "456321789",
          "ChequePaymentUnderCollection": "456321789",
          "BankTransferPaymentUnderCollection": "456321789",
          "CreditCardPaymentUnderCollection": "456321789",
          "E_PaymentUnderCollection": "456321789",
          "OverdraftUnderCollection": "456321789",
          "SAPReference": "456321789",
          "HHReference": null,
          "SystemReference": "456321789",
          "createdAt": "2025-03-08T08:15:27.193Z",
          "updatedAt": "2025-04-07T13:56:23.376Z",
          "TR_Outstanding": [],
          "PriceList": {
            "PriceID": "PR001",
            "Description": "Standard Pricing",
            "TaxID": "TX001",
            "CurrencyID": "SAR",
            "IsActive": true,
            "StartDate": "2024-07-01T00:00:00.000Z",
            "EndDate": "2024-12-31T23:59:59.000Z",
            "JT_ItemsPriceList": []
          },
          "PaymentTerm": {
            "PaymentTermID": "PT001",
            "TermNameAR": "Payment Term 1",
            "TermNameEN": "Payment Term 1",
            "BranchID": "3",
            "DaysUntilDue": 0,
            "MaximumOpenInvoices": null,
            "MaximumOverdueInvoices": null,
            "createdAt": "2025-01-27T08:05:38.670Z",
            "updatedAt": "2025-01-27T08:05:15.246Z"
          },
          "numberOfVisits": 2,
          "numberOfPurchasedItems": 11
        },
        "visitDays": ["Sunday"]
      }
    },
    {
      "customer": {
        "profile": {
          "CustomerID": "C002",
          "CustomerType": "Retail",
          "CustomerNameAR": "حسن",
          "CustomerNameEN": "hassan",
          "TradeName": "hassan trading",
          "BranchID": "3",
          "SubRangeID": "SR001",
          "PriceID": "PR001",
          "TaxID": "TX001",
          "MaxOrderValue": null,
          "TargetVisit": null,
          "TargetValue": null,
          "MasterCreditLimit": null,
          "IndividualCreditLimit": "900",
          "Balance": "1500.75",
          "OpenOrder": null,
          "OpenInvoice": null,
          "StopSales": false,
          "IsActive": true,
          "SatffID": "1103",
          "CustomerTypeID": "CT001",
          "CategoryID": "CC001",
          "ClassID": "Cl001",
          "GroupID": "CG001",
          "AddressAR": null,
          "AddressEN": null,
          "PaymentTermID": "PT001",
          "AllowCash": true,
          "AllowCredit": true,
          "AllowBankTransfer": true,
          "AllowOverDraft": true,
          "AllowCheck": true,
          "AllowEPayment": true,
          "PhoneNo": null,
          "MobileNo": null,
          "WhatsappNo": null,
          "E_mail": null,
          "UserID": null,
          "TokenID": "2e1bbfce-9af4-4f12-98e6-3a385ec6a6dd",
          "CountryID": "KSA",
          "Remarks": null,
          "StateID": "ST001",
          "RegionID": "R001",
          "CityID": "CT001",
          "AreaID": "AR001",
          "PostalZone": 0,
          "BuildingNo": 0,
          "IsB2B": true,
          "VatRegistrationNo": null,
          "Taxpayer": null,
          "VatTypeID": null,
          "VatValues": null,
          "EGSCode": null,
          "ZatcaUsername": null,
          "ZatcaPassoword": null,
          "Longitude": 46.6255,
          "Latitude": 24.7235,
          "RoutesID": "68A84",
          "IsParent": false,
          "ParentCustomerID": null,
          "UseParentCreditLimit": false,
          "CreatedOn": "2025-01-27T08:13:03.120Z",
          "ModifiedOn": "2025-01-27T08:13:03.120Z",
          "ConfigSource": 0,
          "CashAccount": null,
          "CheckAccount": null,
          "BankTransferAccount": null,
          "CreditCardAccount": null,
          "OverdraftAccount": null,
          "E_PaymentAccount": null,
          "CashPaymentUnderCollection": null,
          "ChequePaymentUnderCollection": null,
          "BankTransferPaymentUnderCollection": null,
          "CreditCardPaymentUnderCollection": null,
          "E_PaymentUnderCollection": null,
          "OverdraftUnderCollection": null,
          "SAPReference": null,
          "HHReference": null,
          "SystemReference": null,
          "createdAt": "2025-01-27T08:13:03.120Z",
          "updatedAt": "2025-04-07T13:57:06.403Z",
          "TR_Outstanding": [
            {
              "OutstandingID": "INV-back-0000001",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "SF0023",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000004",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "11",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "3500",
              "RemainingTotal": "-1999.25",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000005",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000006",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000007",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000008",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000009",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000010",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000011",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1500.75",
              "PaidTotal": "0",
              "RemainingTotal": "1500.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000012",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000013",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000014",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000015",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000016",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000017",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000018",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000019",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            },
            {
              "OutstandingID": "INV-back-0000020",
              "CustomerID": "C002",
              "DocumentTypeID": "Invoice",
              "StaffID": "RM-124",
              "InvoiceTotal": "1700.75",
              "PaidTotal": "0",
              "RemainingTotal": "1700.75",
              "IssueDate": "2025-03-12T12:00:00.000Z",
              "DueDate": "2025-03-12T12:00:00.000Z"
            }
          ],
          "PriceList": {
            "PriceID": "PR001",
            "Description": "Standard Pricing",
            "TaxID": "TX001",
            "CurrencyID": "SAR",
            "IsActive": true,
            "StartDate": "2024-07-01T00:00:00.000Z",
            "EndDate": "2024-12-31T23:59:59.000Z",
            "JT_ItemsPriceList": []
          },
          "PaymentTerm": {
            "PaymentTermID": "PT001",
            "TermNameAR": "Payment Term 1",
            "TermNameEN": "Payment Term 1",
            "BranchID": "3",
            "DaysUntilDue": 0,
            "MaximumOpenInvoices": null,
            "MaximumOverdueInvoices": null,
            "createdAt": "2025-01-27T08:05:38.670Z",
            "updatedAt": "2025-01-27T08:05:15.246Z"
          },
          "numberOfVisits": 5,
          "numberOfPurchasedItems": 607
        },
        "visitDays": ["Tuesday", "Wednesday"]
      }
    }
  ],
  "promotionTypes": [
    {
      "PromotionTypeID": "f9e37df7-c0f3-458e-8bf3-9f44a39d46cd",
      "PromotionType": "FreeItem",
      "DescriptionAR": "عرض إعطاء منتجات مجانية",
      "DescriptionEN": "New",
      "InputValue": "Quantity",
      "OutputValue": "FreeItem"
    }
  ],
  "PromotionsOfCustomers": [
    {
      "PromotionID": "P20250224VQ5",
      "DescriptionAR": "عرض مياه زلال اختياري 300 كرتون و احصل على 100 كرتون",
      "DescriptionEN": "100 carton free",
      "PromotionTypeID": "f9e37df7-c0f3-458e-8bf3-9f44a39d46cd",
      "ActiveFrom": "2025-02-23T21:00:00.000Z",
      "ActiveTo": "2025-04-29T20:59:59.999Z",
      "IsActive": true,
      "AllowCash": true,
      "AllowCredit": true,
      "AllowBankTransfer": true,
      "AllowOverDraft": true,
      "AllowCheck": true,
      "AllowEPayment": true,
      "SoloPromotion": false,
      "Default": false,
      "Optional": true,
      "Outcomes": [
        {
          "income": "100",
          "outcome": "10",
          "freeItems": ["IT001"],
          "latest": false
        }
      ],
      "IncomeItems": ["IT001", "IT002", "IT003", "IT006"],
      "Customers": ["C002"]
    }
  ]
};

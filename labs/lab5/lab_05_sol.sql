DROP DATABASE IF EXISTS carpet_store;                                               --Makes re-running code more convenient.

CREATE DATABASE carpet_store;
USE carpet_store;

CREATE TABLE CarpetOriginCountries (                                                -- Validation table of carpet origin coutries
    CarpetOriginCountryCode     INT unsigned NOT NULL AUTO_INCREMENT,           
    CarpetOriginCountry         VARCHAR(150),
    PRIMARY KEY                 (CarpetOriginCountryCode)
);

CREATE TABLE CarpetMaterials (                                                      -- Validation table of carpet materials
    CarpetMaterialCode          INT unsigned NOT NULL AUTO_INCREMENT,
    CarpetMaterial              VARCHAR(50) NOT NULL,
    PRIMARY KEY                 (CarpetMaterialCode)
);

CREATE TABLE Inventory (                                                            -- Data table which tracks past and present inventory of carpets. 
    CarpetID                    INT unsigned NOT NULL AUTO_INCREMENT,
    CarpetOriginCountryCode     INT unsigned NOT NULL,                              -- One-to-many relationship
    CarpetMaterialCode          INT unsigned NOT NULL,                              -- One-to-many relationship
    CarpetManufactureYear       DATE NOT NULL,
    CarpetWidth                 INT NOT NULL,
    CarpetLength                INT NOT NULL,
    CarpetPurchasePrice         DECIMAL(7,2),
    CarpetDateAcquired          DATE NOT NULL,
    CarpetMarkupPercent         INT NOT NULL,
    CarpetIsInStock             BOOLEAN NOT NULL,
    FOREIGN KEY                 (CarpetOriginCountryCode) REFERENCES 
                                    CarpetOriginCountries(CarpetOriginCountryCode),                              
    FOREIGN KEY                 (CarpetMaterialCode) REFERENCES 
                                    CarpetMaterials(CarpetMaterialCode),
    PRIMARY KEY                 (CarpetID) 
);

CREATE TABLE Customers (                                                            -- Data table which tracks customers.
    CustomerID                  INT unsigned NOT NULL UNIQUE AUTO_INCREMENT,
    CustomerMobileNumber        VARCHAR(20) UNIQUE,
    CustomerFirstName           VARCHAR(150) NOT NULL,
    CustomerLastName            VARCHAR(150) NOT NULL,
    CustomerAddress             VARCHAR(50) NOT NULL,
    CustomerCity                VARCHAR(50) NOT NULL,
    CustomerState               VARCHAR(2) NOT NULL,
    CustomerIsActive            BOOLEAN NOT NULL,
    PRIMARY KEY                 (CustomerID)
);

CREATE TABLE TransactionTypes (                                                     -- Validation table for possible transaction types, so the Transaction record itself contains the information, not just it's subtables.
    TransactionTypeCode         INT unsigned NOT NULL UNIQUE AUTO_INCREMENT,
    TransactionTypeName         VARCHAR(10) NOT NULL,
    PRIMARY KEY                 (TransactionTypeCode)
);

CREATE TABLE CarpetTransactions (                                                   -- Data table containing all transactions involving the store's stock.
    TransactionID               INT unsigned NOT NULL UNIQUE AUTO_INCREMENT,
    CustomerID                  INT unsigned NOT NULL,                              -- One-to-many relationship; a given TransactionID will have one customerID, but one CustomerID can be associated with many TransactionIDs.
    CarpetID                    INT unsigned NOT NULL,                              -- One-to-many relationship; in the event that a carpet is returned, it will be linked to multiple TransactionIDs, but a single TransactionID will only be associated withe one CarpetID.
    TransactionDate             DATE NOT NULL,
    TransactionTypeCode         INT unsigned NOT NULL,
    PRIMARY KEY                 (TransactionID),
    FOREIGN KEY                 (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY                 (CarpetID) REFERENCES Inventory(CarpetID) ON DELETE RESTRICT, -- If a given CarpetID appears in the Transactions table, that carpet cannot be deleted from the Inventory.
    FOREIGN KEY                 (TransactionTypeCode) REFERENCES 
                                    TransactionTypes(TransactionTypeCode)
);

CREATE TABLE CarpetSales (                                                          -- Subtable of CarpetTransactions which tracks carpet sales.
    TransactionID               INT unsigned NOT NULL UNIQUE,                       -- One-to-one relationship
    SalePrice                   DECIMAL (7,2),
    CarpetReturned              BOOLEAN,
    PRIMARY KEY                 (TransactionID),
    FOREIGN KEY                 (TransactionID) REFERENCES 
                                    CarpetTransactions(TransactionID)
);


CREATE TABLE CarpetTrials (                                                         -- Subtable of CarpetTransactions which tracks carpet loans and returns. One-to-One relationship.
    TransactionID               INT unsigned NOT NULL UNIQUE,
    TrialPeriodStartDate        DATE NOT NULL,
    TrialPeriodEndDate          DATE NOT NULL,
    ActualCarpetReturnDate      DATE NOT NULL CHECK
                                    (ActualCarpetReturnDate >= TrialPeriodStartDate),   -- Ensures that a carpet cannot be returned before it is loaned out. However, no relationship to the TrialEndDate is enforced.
    PRIMARY KEY                 (TransactionID),
    FOREIGN KEY                 (TransactionID) REFERENCES 
                                    CarpetTransactions(TransactionID)
);

/*
Substable of CarpetTransactions which tracks sold carpet which are returned. Unlike CarpetTransaction's other subtables, 
this one has a many-to-many relationship with it's parent table, as each return references an original purchase transaction 
and a return transaction.
*/
CREATE TABLE CarpetReturn (                                                         
    TransactionID               INT unsigned NOT NULL UNIQUE,                       
    OriginalSaleTransactionID   INT unsigned NOT NULL UNIQUE,
    ActualCarpetReturnDate      DATE NOT NULL,
    RefundAmount                DECIMAL (7,2),
    PRIMARY KEY                 (TransactionID),
    FOREIGN KEY                 (TransactionID) REFERENCES 
                                    CarpetTransactions(TransactionID),
    FOREIGN KEY                 (OriginalSaleTransactionID) REFERENCES 
                                    CarpetTransactions(TransactionID)
);

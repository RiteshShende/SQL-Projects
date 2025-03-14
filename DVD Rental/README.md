# Solving-Business-Queries-using-PostgreSQL-on-DVD-Rental-Database

## Prerequisites

  1. PostgreSQL
  2. DVD Rental .rar file
  3. pgAdmin

## PostgreSQL

PostgreSQL is an advanced, enterprise class open source relational database that supports both SQL (relational) and JSON (non-relational) querying. It is a highly stable database management system, backed by more than 20 years of community development which has contributed to its high levels of resilience, integrity, and correctness. PostgreSQL is used as the primary data store or data warehouse for many web, mobile, geospatial, and analytics applications. 

PostgreSQL has a rich history for support of advanced data types, and supports a level of performance optimization that is common across its commercial database counterparts, like Oracle and SQL Server.

## DVD rental database

A DVD rental database is a structured collection of information that stores data related to DVD rentals. It is designed to efficiently manage and organize various aspects of a DVD rental business, such as inventory management, customer information, rental transactions, and more. This type of database enables rental businesses to streamline their operations, track rentals and returns, and provide better customer service

The DVD rental database typically consists of multiple interconnected tables that hold different types of data. 
Movies Table: This table contains information about the movies available for rental, including their titles, release dates, genres, and other relevant details. Each movie is assigned a unique identifier, which serves as a primary key.

Customers Table: This table stores customer information, such as names, addresses, contact details, and membership status. Each customer is assigned a unique identifier as a primary key, which helps in identifying and tracking individual customer activity.

Rentals Table: This table records the rental transactions, including the customer renting a specific movie, the rental start and return dates, and any associated fees. It typically includes foreign keys that reference the customer and movie tables to establish relationships.

Returns Table: This table tracks the return transactions, including the rental ID, return date, and any applicable late fees. It helps to manage the inventory and calculate charges accurately.

Inventory Table: This table maintains the inventory of available DVDs, linking each movie to the number of copies in stock. It helps in tracking the availability of movies for rental and managing stock levels.

Payments Table: This table stores payment information related to DVD rentals, including payment method, amount, and transaction details. It helps in managing billing and financial aspects of the rental business.

The DVD rental database allows rental businesses to perform various operations, such as adding new movies to the inventory, registering new customers, recording rentals and returns, generating reports on customer activity, and handling payment transactions.

By leveraging a well-designed DVD rental database, businesses can enhance their efficiency, improve customer service, and gain valuable insights into rental trends and preferences. The database serves as a central hub of information, facilitating better decision-making and ensuring smoother operations in the DVD rental industry.

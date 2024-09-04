# Employee Schedule Management System

## Overview

The **Employee Schedule Management System** is an automated solution designed to streamline the shift scheduling process for student employees at Syracuse University Dining Services. This project leverages SQL Server and Microsoft PowerApps to create an efficient and user-friendly scheduling system.

## Features

- **Automated Shift Scheduling**: Automatically generate and manage shift schedules for student employees.
- **Database Management**: A robust relational database model to store and manage scheduling data.
- **Data Analysis & Extraction**: Advanced SQL queries, including stored procedures and views, for efficient data retrieval and analysis.
- **Custom UI**: A PowerApps-based interface allowing users to interact with the scheduling system seamlessly.

## Technologies Used

- **SQL Server**: For database management and complex query execution.
- **Microsoft PowerApps**: For building the user interface and interacting with the database.
- **ER Modeling**: Designed an Entity-Relationship model, later translated into a relational schema.
- **SQL Scripting**: Implemented stored procedures, views, and complex join queries.

## Project Structure

```plaintext
├── database
│   ├── schema.sql                # SQL scripts for creating the database schema
│   ├── procedures.sql            # SQL scripts for stored procedures
│   └── views.sql                 # SQL scripts for views and complex queries
├── powerapp
│   ├── app_design.md             # Documentation for the PowerApp interface design
│   └── screenshots               # Folder containing screenshots of the PowerApp interface
├── docs
│   ├── ER_model.png              # ER diagram of the database
│   └── requirements.md           # Project requirements and specifications
└── README.md                     # Project documentation


## Getting Started

### Prerequisites

- **SQL Server**: Ensure SQL Server is installed and running on your local machine.
- **Microsoft PowerApps**: Access to PowerApps to interact with the scheduling system.

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/bastinjob/employee-schedule-management-system.git
   cd employee-schedule-management-system

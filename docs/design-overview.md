# DevOps Lite Project: Design Overview

## Introduction

This document provides a high-level design overview of the DevOps Lite project, which implements a multi-service infrastructure with automated management and continuous integration practices. The project demonstrates key DevOps concepts including system administration, automation, version control, and service orchestration.

## Project Goals

The primary goals of this project are to:

1. Create a robust infrastructure for hosting multiple web applications
2. Implement secure user and permission management
3. Automate routine maintenance tasks
4. Set up efficient traffic routing through reverse proxy and load balancing
5. Apply version control best practices to infrastructure code

## System Architecture

The DevOps Lite project is built on an AWS EC2 instance running Ubuntu Server. The architecture consists of multiple layers working together to provide a complete solution:

```
┌─────────────────────────────────────────────────────────┐
│                   AWS EC2 Instance                      │
│                                                         │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐  │
│  │ User/Group  │    │  Scheduled  │    │  Version    │  │
│  │ Management  │    │    Tasks    │    │   Control   │  │
│  └─────────────┘    └─────────────┘    └─────────────┘  │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │               NGINX Web Server                  │    │
│  │      (Reverse Proxy & Load Balancing)           │    │
│  └─────────────────────────────────────────────────┘    │
│                          │                               │
│     ┌──────────────┬─────┴─────┬──────────────┐         │
│     │              │           │              │         │
│  ┌──▼───┐       ┌──▼───┐    ┌──▼───┐       ┌──▼───┐    │
│  │Python│       │NodeJS│    │NodeJS│       │Future│    │
│  │App   │       │App 1 │    │App 2 │       │Apps  │    │
│  │(8000)│       │(3000)│    │(3001)│       │  ... │    │
│  └──────┘       └──────┘    └──────┘       └──────┘    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## Component Design

### 1. Infrastructure Layer

**AWS EC2 Instance:**
- Instance Type: t2.micro
- Operating System: Ubuntu Server 24.04 LTS
- Networking: Public subnet with security group controlling access

**Security Model:**
- SSH access for administration
- HTTP access for web traffic
- Internal services protected from direct external access
- Principle of least privilege applied through user/group permissions

### 2. User and Access Management

**Design Principles:**
- Separation of duties through role-based access
- Group-based permission management for simplified administration
- Dedicated shared directories with appropriate permissions

**Implementation:**
- User accounts for specific roles (devadmin, webadmin, automation)
- Group structure (dev, web, ops) aligned with responsibilities
- Directory permissions enforced through group membership

### 3. Automation Framework

**Scheduled Tasks:**
- Daily backups of web content
- Hourly system monitoring
- Regular service health checks

**Automation Philosophy:**
- Proactive monitoring to identify issues before they become critical
- Standardized logging for all automated tasks
- Rotation and cleanup of generated files to prevent disk space issues

### 4. Web Service Architecture

**Nginx Layer:**
- Single entry point for all web traffic
- Path-based routing to backend services
- Load distribution across multiple instances of the same service

**Application Services:**
- Python application demonstrating basic web service
- Duplicate Node.js applications showcasing load balancing
- Decoupled design allowing independent scaling of services

### 5. Version Control Strategy

**Repository Structure:**
- Organized by component type (scripts, configs, docs)
- .gitignore configured to exclude sensitive data
- Documentation integrated with implementation code

**Development Workflow:**
- Changes tracked through Git
- GitHub used as central repository
- Documentation updated alongside code changes

## Design Decisions

### Why Nginx for Reverse Proxy and Load Balancing?

Nginx was selected as the web server and proxy solution due to:
- High performance and low resource footprint
- Built-in support for both reverse proxy and load balancing
- Extensive configuration options and robust community support
- Suitability for production environments

### Why Separate Configuration Files?

The decision to use separate configuration files for reverse proxy and load balancing was made to:
- Improve modularity and maintainability
- Allow for independent testing of each configuration
- Simplify troubleshooting and future modifications
- Demonstrate different Nginx configuration patterns

### Why Bash for Automation?

Bash scripting was chosen for automation because:
- It's universally available on Linux systems without additional dependencies
- Direct access to system commands and pipelines
- Integration with cron for scheduling
- Simplicity for common system administration tasks

## Future Enhancement Possibilities

The current design can be extended in several ways:

1. **High Availability Improvements:**
   - Multiple EC2 instances with shared state
   - Database integration for stateful applications

2. **Security Enhancements:**
   - SSL/TLS implementation for encrypted connections
   - More granular firewall rules with UFW
   - Enhanced authentication mechanisms

3. **Monitoring and Alerting:**
   - Integration with monitoring solutions (e.g., Prometheus, Grafana)
   - Alert configuration for critical events
   - Performance metrics collection and analysis

4. **Deployment Pipeline:**
   - CI/CD integration for automated testing and deployment
   - Blue-green deployment strategy for zero-downtime updates
   - Container orchestration for improved scalability

## Conclusion

The DevOps Lite project design demonstrates fundamental DevOps principles through practical implementation. It provides a foundation for understanding how various components work together to create a functional, maintainable, and secure web infrastructure. The modular nature of the design allows for incremental improvements and extensions as requirements evolve.

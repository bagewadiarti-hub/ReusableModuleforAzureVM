// Jenkinsfile
// CI/CD Pipeline - Auto installs Terraform, runs Init → Plan → Apply automatically

pipeline {

    agent any

    // ── Auto-install Terraform via Jenkins Tool ──────────────────────────────
    tools {
        terraform 'terraform'   // matches the name set in Jenkins → Tools → Terraform
    }

    // ── Environment Variables (Azure credentials from Jenkins) ───────────────
    // Credential IDs match exactly what is stored in Jenkins Credentials page
    environment {
        ARM_CLIENT_ID           = credentials('azure-client-id')        // ← matches Jenkins ID
        ARM_CLIENT_SECRET       = credentials('azure-client-secret')    // ← matches Jenkins ID
        ARM_SUBSCRIPTION_ID     = credentials('azure-subscription-id')  // ← matches Jenkins ID
        ARM_TENANT_ID           = credentials('azure-tenant-id')        // ← matches Jenkins ID
        TF_VAR_ssh_public_key   = credentials('SSH_PUBLIC_KEY')         // ← matches Jenkins ID
    }

    stages {

        // ── Stage 1: Checkout Code from GitHub ──────────────────────────────
        stage('Checkout') {
            steps {
                echo '📥 Checking out code from GitHub...'
                checkout scm
            }
        }

        // ── Stage 2: Verify Terraform is Available ───────────────────────────
        stage('Verify Terraform') {
            steps {
                echo '🔍 Verifying Terraform installation...'
                bat 'terraform version'
            }
        }

        // ── Stage 3: Terraform Init ──────────────────────────────────────────
        stage('Terraform Init') {
            steps {
                echo '⚙️ Initializing Terraform and connecting to Azure remote backend...'
                bat 'terraform init -input=false'
            }
        }

        // ── Stage 4: Terraform Validate ──────────────────────────────────────
        stage('Terraform Validate') {
            steps {
                echo '✅ Validating Terraform configuration files...'
                bat 'terraform validate'
            }
        }

        // ── Stage 5: Terraform Format Check ─────────────────────────────────
        stage('Terraform Format Check') {
            steps {
                echo '🎨 Checking Terraform code formatting...'
                bat 'terraform fmt -check -recursive'
            }
        }

        // ── Stage 6: Terraform Plan ──────────────────────────────────────────
        stage('Terraform Plan') {
            steps {
                echo '📋 Running Terraform Plan - previewing changes...'
                bat 'terraform plan -out=tfplan -input=false'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
                }
            }
        }

        // ── Stage 7: Terraform Apply ─────────────────────────────────────────
        stage('Terraform Apply') {
            steps {
                echo '🚀 Applying Terraform changes to Azure...'
                bat 'terraform apply -input=false -auto-approve tfplan'
            }
        }

        // ── Stage 8: Show Outputs ────────────────────────────────────────────
        stage('Show Outputs') {
            steps {
                echo '📤 Terraform Outputs (VM IDs and IP Addresses):'
                bat 'terraform output'
            }
        }
    }

    // ── Post-build Actions ───────────────────────────────────────────────────
    post {
        success {
            echo '✅ Pipeline completed! All Azure VMs (dev + staging) are deployed.'
        }
        failure {
            echo '''
            ❌ Pipeline failed! Common causes:
               - Azure credentials missing or wrong ID names in Jenkins
               - Wrong storage account name in main.tf backend block
               - Terraform fmt formatting errors in .tf files
            '''
        }
        always {
            node('built-in') {
                echo '🧹 Cleaning workspace...'
                cleanWs()
            }
        }
    }
}

The below steps are to be followed in order to execute the terraform code to provision the resources in AWS Cloud.

1. Install aws cli version in your local using the below commands based upon your OS. Skip the step if already installed.
   
   For Linux:
       curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
       unzip awscliv2.zip
       sudo ./aws/install
       Verify the instalaltion using "aws --version"

   For Windows:
       For the latest version of the AWS CLI: https://awscli.amazonaws.com/AWSCLIV2.msi
       Run the downloaded MSI installer and follow the on-screen instructions. By default, the AWS CLI installs to C:\Program Files\Amazon\AWSCLIV2. 
       To confirm the installation, open the Start menu, search for cmd to open a command prompt window, and at the command prompt use the aws --version command. 

   For macOS:
       curl "https://awscli.amazonaws.com/AWSCLIV2-2.0.30.pkg" -o "AWSCLIV2.pkg"
       sudo installer -pkg AWSCLIV2.pkg -target /
       Verify the instalaltion using "which aws and/or aws --version"

2. Run "aws configure" command to set the AWS Security Credentials.

   Below is an example:

    $ aws configure
      AWS Access Key ID [****************5XCM]: AKIA4DFZ554QYCMS5XCM
      AWS Secret Access Key [****************0Nt1]: Z26IwmpEPCmFncdPMqbi8hAC0VsJuY67xrFs0Nt1
      Default region name [us-east-1]: us-east-1
      Default output format [json]: json        
   
3. Install GIT. Skip the step, if already installed.

   If you’re on Fedora (or any closely-related RPM-based distribution, such as RHEL or CentOS), you can use dnf:

     $ sudo dnf install git-all

   If you’re on a Debian-based distribution, such as Ubuntu, try apt:

     $ sudo apt install git-all

   For macOS:
     brew install git

   For Windows:
     Follow the doc "https://phoenixnap.com/kb/how-to-install-git-windows"


3. Clone the code from the GitHub Repo.
   git clone git@github.com:vasireddiprudhvi/assessment.git

2. cd assessment

3. Run the below commands one by one to provision the resources in AWS Cloud.
  
   terraform init 
   terraform apply


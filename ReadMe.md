# Scripts
The script need some variables to run alonmg with e.g.
```
./argo-install.sh adminpassword developerpassword ingresshostname
```
Where in above three parameters variables have been used    
- **adminpassword**  - admin password for argo admin user
- **developerpasssword**  - password for argo developer user id 
- **ingresshostname**  - is the web hostname pointing to ingress controller NLB or ALB, using which customer will access argocd web application.

***Note*** In the scriptfollowing are required.
download and put content from https://github.com/sharmavijay86/argocd-install.git in a git repo along side of this argo-install script.
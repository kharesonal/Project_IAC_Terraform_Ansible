# Configuration and Deployment of Mern stack application on aws with Ansible

**Step 1. Ansible Configuration**

To set up Ansible for communication with your AWS EC2 instances, follow these steps:

- **Install Ansible on your local machine or a control server:**
  
```
  sudo apt update
  sudo apt install ansible
```
- **Create an inventory file named "inventory.ini" that lists your EC2 instances:**
  
```
[webservers]
ec2-instance-1 ansible_host=15.152.36.178 ansible_user=ubuntu ansible_ssh_private_key_file=sonal_instance.pem
[backends]
ec2-instance-2 ansible_host=13.208.209.155 ansible_user=ubuntu ansible_ssh_private_key_file=sonal_instance.pem
```

- **Test your Ansible setup by running:**
  
`
   ansible all -m ping -i inventory.ini
`

   ![image](https://github.com/user-attachments/assets/1619d09b-6444-4a7a-a9c4-8006b2fc1c43)


**Step 2. Webserver and database server Setup**

Create an Ansible playbook named playbook.yml to install Node.js, NPM, and deploy your MERN application.

**The Ansible playbook performs the following tasks:**

- **Install Nginx: Set up the Nginx web server on the target servers.**
  
  ![image](https://github.com/user-attachments/assets/2064fc6f-693e-4c63-bc28-f330849c2d4f)

- **Install Node.js and npm: Install Node.js and its package manager, npm, along with their prerequisites.**

   ![image](https://github.com/user-attachments/assets/e6f0bb01-3ba3-4998-b492-71b4c6451ac9)

  
- **Install Git: Ensure Git is installed for version control and cloning repositories.**

   ![image](https://github.com/user-attachments/assets/8cfeea76-1c52-4de3-943a-5e8463cf2e7c)

- **Clone a Git Repository: Clone the specified Git repository to the target server.**

  ![image](https://github.com/user-attachments/assets/0a84b0d7-69e3-414b-babb-667fc0af0728)

- **Change Permissions: Set the correct permissions for the cloned directory.**

  ![image](https://github.com/user-attachments/assets/258da574-f6a8-47f3-a8ca-dc0cde236b6f)

 - **Update url.js in the Frontend: Copy the url.js file from the control node to the frontend server.**

   ![image](https://github.com/user-attachments/assets/1050f251-9a7c-418f-a382-7acde72c4baa)

 - **Update .env of the Backend: Copy the .env file from the control node to the backend server.**

   ![image](https://github.com/user-attachments/assets/a76fbfbe-249e-4324-a272-5f6ce17f3601)

 - **Setup and Start npm in Frontend: Install npm dependencies and start the frontend application.**

   ![image](https://github.com/user-attachments/assets/828826d2-1150-42e0-90d0-1c0927390e36)

- **Run npm Dependencies and Node.js Application in Backend: Install npm dependencies and run the Node.js application in the backend.**

  ![image](https://github.com/user-attachments/assets/dea82c98-4d2b-4e0b-bb76-96114afcdfd5)

  **Run the playbook.yml using command:**

  `
  ansible-playbook -i inventory.ini playbook.yml
  `
  ![image](https://github.com/user-attachments/assets/125df00b-1ca1-4374-91a4-18ec41d117be)

  **Expected Output**

  ![Screenshot 2024-10-13 125119](https://github.com/user-attachments/assets/81499e20-f319-4293-bf6b-0d34373d428c)
  

  ![Screenshot 2024-10-13 125151](https://github.com/user-attachments/assets/0ae0a5cb-3ae4-4391-9efd-ea2eeab02e40)

  



  










  



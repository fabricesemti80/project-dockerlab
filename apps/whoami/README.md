# Simple Web App - Traefik Whoami

A super simple web application using Traefik's whoami service to demonstrate Dokploy deployment.

## What is this?

This is a tiny web application that shows information about the requests made to it. It's perfect for learning how to deploy applications with Dokploy!

## What does it do?

When you visit the website, it will show you:
- Your IP address
- Request headers
- Host information
- Other technical details about your visit

It's like a magic mirror that tells you about your internet visit! 🪄

## Files in this folder

- `docker-compose.yaml` - The recipe that tells Dokploy how to run your app

## How to deploy this in Dokploy (Step by Step)

### Step 1: Open Dokploy
1. Open your web browser
2. Go to your Dokploy website (like `http://your-server-ip:3000`)
3. Log in with your username and password

### Step 2: Create a new project
1. Click on "Projects" in the left menu
2. Click the big blue "New Project" button
3. Give your project a name, like "My First App"
4. Click "Create"

### Step 3: Add your application
1. In your project, click "New Application"
2. Choose "Docker Compose" (not Dockerfile!)
3. Give your app a name, like "Whoami App"

### Step 4: Connect to GitHub (The Magic Part!)
1. Click "Connect to Git Repository"
2. You'll see a GitHub logo - click it!
3. GitHub will ask: "Can this website access your GitHub?" 
4. Click "Authorize" or "Allow" - it's safe! ✅

### Step 5: Choose your repository
1. You'll see a list of your GitHub projects
2. Find the one with this simple-web-app folder
3. Click "Connect" next to it

### Step 6: Set up the deployment
1. **Branch**: Choose "main" (or "master")
2. **Path**: Type `apps/simple-web-app` (this is where our docker-compose.yaml is!)
3. **Auto Deploy**: Turn this ON (so it updates when you change the code)

### Step 7: Configure the application
1. **Environment**: Choose "Development" for now
2. **Network**: Choose "dokploy-network" (this is the special network Dokploy made)
3. **Restart Policy**: Choose "Unless Stopped"

### Step 8: Set up the website address
1. Click "Add Domain"
2. Type a name like `whoami` 
3. Your full website will be: `whoami.your-domain.com`
4. Turn on "Enable HTTPS" - this makes your website secure! 🔒

### Step 9: Save and deploy!
1. Click "Save Changes" at the bottom
2. Dokploy will say "Building..." - this means it's setting up your app
3. Wait a minute or two...

### Step 10: Visit your website!
1. When it says "Running", your app is ready! 🎉
2. Click the link or go to your domain in the browser
3. You should see a page with technical information about your visit

## What you should see

The whoami app will show you fun information like:
```
Hostname: whoami-1
IP: 172.18.0.3
RemoteAddr: 10.0.0.1:54321
GET / HTTP/1.1
Host: whoami.your-domain.com
User-Agent: Mozilla/5.0...
```

It's like the computer is introducing itself to you! 👋

## Troubleshooting (What to do if it doesn't work)

### Problem: "Building..." forever
- Wait 5 minutes, sometimes it takes time
- Check if your GitHub repository is public (Dokploy needs to see it)

### Problem: "Error" message
- Make sure you typed `apps/simple-web-app` exactly
- Check that your docker-compose.yaml file exists in that folder

### Problem: Website shows "Not Found"
- Make sure you turned on HTTPS
- Check that your domain name is correct
- Wait a few minutes for the internet to update

### Problem: Can't connect to GitHub
- Make sure you clicked "Allow" when GitHub asked for permission
- Try disconnecting and reconnecting your GitHub

## Making changes to your app

### Change the website name
1. Go to your app in Dokploy
2. Click "Edit"
3. Change the domain name
4. Click "Save Changes"
5. Your website will update automatically!

### Change the app settings
1. Edit the `docker-compose.yaml` file in your GitHub
2. Save the changes
3. Dokploy will automatically rebuild your app (because Auto Deploy is ON!)

## Understanding the docker-compose.yaml

```yaml
services:
  whoami:
    image: traefik/whoami    # This is the app we want to run
    restart: unless-stopped  # Keep it running
    # Domain configuration is handled through Dokploy UI, not in this file!
    # When you deploy in Dokploy, you'll set your domain name in the web interface.
    # Dokploy will automatically add the correct Traefik labels for routing and HTTPS.
```

### **Important: Domain Configuration - Two Ways to Do It!**

You have **TWO options** for setting up your domain. Here they are:

---

## 🚀 Option 1: Dokploy UI (RECOMMENDED for beginners!)

**This is the EASIEST way!** ⭐

### **How it works:**
1. **In Dokploy UI**: When you create your application, there's a special field for the domain name
2. **Dokploy handles the rest**: It automatically adds the correct routing rules and SSL certificates
3. **Easy changes**: You can change your domain anytime without editing code

### **Why choose this option?**
- ✅ **Easier**: No need to edit YAML files for domain changes
- ✅ **Safer**: Less chance of breaking your app with syntax errors
- ✅ **Automatic**: SSL certificates are handled for you
- ✅ **Flexible**: Change domains without code changes or Git commits
- ✅ **Visual**: See and manage all your domains in one place

### **What Dokploy does automatically:**
- Adds the correct Traefik routing labels
- Sets up HTTPS with free SSL certificates
- Configures the domain name
- Updates the docker-compose.yaml with the right settings

---

## 🔧 Option 2: Manual Docker Compose (Advanced users)

**This is for when you want full control!** 🛠️

### **How it works:**
You can manually add domain configuration directly to your docker-compose.yaml file:

```yaml
services:
  whoami:
    image: traefik/whoami
    restart: unless-stopped
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`your-domain.com`)"
      - "traefik.http.routers.whoami.entrypoints=websecure"
      - "traefik.http.routers.whoami.tls.certresolver=letsencrypt"
```

### **When to use this option:**
- You want to version control your domain configuration
- You're deploying without Git integration
- You need custom Traefik routing rules
- You're an advanced user who likes YAML files! 😄

### **Things to be careful about:**
- ❌ **Syntax errors**: YAML is picky about spaces and quotes
- ❌ **SSL setup**: You need to handle certificates manually
- ❌ **Domain changes**: Requires editing code and redeploying
- ❌ **Git history**: Domain changes show up in version control

---

## 🤔 Which Option Should You Choose?

### **Choose Option 1 (Dokploy UI) if:**
- You're learning Dokploy
- You want things to be easy
- You might change domains later
- You don't want to worry about SSL certificates
- You prefer a visual interface

### **Choose Option 2 (Manual) if:**
- You're comfortable with YAML
- You want everything in your Git repository
- You need custom routing rules
- You're deploying without Git integration
- You like having full control

### **Pro Tip:**
**Start with Option 1** (Dokploy UI) to learn how everything works, then try Option 2 later if you need more control! 🎯

---

## 🏗️ High Availability & Scalability in Docker Swarm

**Good news!** This application is pre-configured for **High Availability (HA)** running in your Docker Swarm cluster.

### **Current Setup: High Availability Cluster**
Your whoami app is configured to run as **3 containers** distributed across your **3 manager nodes** (dkr-srv-0, dkr-srv-1, dkr-srv-2).

**What this means:**
- ✅ **High Availability**: If one server goes down, other copies keep working
- ✅ **Load Distribution**: Traffic spreads across multiple containers
- ✅ **Fault Tolerance**: No single point of failure
- ✅ **Scalable**: Easy to increase capacity just by changing a number

### **Understanding the Configuration**

In the `docker-compose.yaml`, we have enabled Swarm mode deployment settings:

```yaml
services:
  whoami:
    image: traefik/whoami
    restart: unless-stopped
    deploy:
      replicas: 3  # Run 3 copies of your app!
      placement:
        constraints:
          - node.role == manager # Distribute across manager nodes
```

### **How it Works:**

#### **✅ Fault Tolerance**
- If `dkr-srv-0` crashes → `dkr-srv-1` and `dkr-srv-2` keep your app running
- If a container dies → Swarm automatically starts a new one
- If a server loses internet → other servers keep your app online

#### **✅ Better Performance**
- 3 containers handle traffic instead of 1
- Traffic automatically balanced across all copies
- Faster response times during high traffic

#### **✅ Zero Downtime Updates**
- Update your app without taking it offline
- New version deploys while old version keeps running
- Automatic rollback if something goes wrong

### **How to Scale Up or Down**

#### **In Dokploy UI:**
1. Go to your application settings
2. Look for "Replicas" or "Scale" option
3. Change the number (e.g., from `3` to `6`)
4. Save changes - Dokploy will automatically create more containers

#### **In docker-compose.yaml:**
Simply change the `replicas` number:
```yaml
deploy:
  replicas: 5  # Scale up to 5 instances!
```

### **When to Adjust Scaling?**

#### **Scale Up (Increase Replicas) if:**
- You expect lots of traffic (marketing launch, viral post)
- You need zero-downtime redundancy (minimum 2 replicas recommended)
- You add more servers to your cluster

#### **Scale Down (Decrease Replicas) if:**
- It's a development branch (1 replica is fine)
- You need to save server resources
- You are debugging a specific issue on one container

### **Recommended Approach:**

#### **Production** 🚀
Keep at least **3 replicas** (as configured). This ensures you can lose a server and still have 2 running, maintaining full redundancy.

#### **Development** 🛠️
You can reduce to **1 replica** to save resources:
```yaml
deploy:
  replicas: 1
```

---

## 🔍 How to Verify Your App is Running on Multiple Servers

Since we configured your app to run with **3 replicas** across your **3 manager nodes**, let's verify it's working correctly!

### **Method 1: Check in Dokploy UI**

1. **Go to your application** in Dokploy
2. **Look for "Replicas" or "Tasks"** - should show `3/3` running
3. **Click on "Tasks" or "Replicas"** to see which servers they're running on
4. **You should see containers on:**
   - dkr-srv-0 (cloud server)
   - dkr-srv-1 (local server 1)
   - dokploy-ctrl2 (local server 2)

### **Method 2: Command Line Verification**

#### **Check All Replicas:**
```bash
# SSH into any of your servers
ssh root@dkr-srv-0

# Check all whoami containers across the swarm
docker service ps whoami
```

**Expected Output:**
```
ID             NAME              IMAGE                NODE           DESIRED STATE   CURRENT STATE
abc123         whoami.1          traefik/whoami       dkr-srv-0  Running         Running 2 minutes ago
def456         whoami.2          traefik/whoami       dkr-srv-1  Running         Running 2 minutes ago
ghi789         whoami.3          traefik/whoami       dokploy-ctrl2  Running         Running 2 minutes ago
```

#### **Check Which Server Each Container is On:**
```bash
# See which server each container is running on
docker service ps whoami --format "table {{.Name}}\t{{.Node}}\t{{.CurrentState}}"
```

#### **Check Container Details:**
```bash
# Get detailed info about all whoami containers
docker ps --filter "name=whoami"
```

### **Method 3: Test Load Balancing**

Since you have 3 replicas, Traefik automatically load balances traffic between them. Here's how to test it:

#### **Method A: Refresh and Watch**
1. Visit your website: `http://whoami.your-domain.com`
2. Refresh the page several times
3. **Look at the "Hostname" field** - it should change between:
   - `whoami.1.dkr-srv-0`
   - `whoami.2.dkr-srv-1`
   - `whoami.3.dokploy-ctrl2`

#### **Method B: Use curl in Terminal**
```bash
# Run this command multiple times
curl http://whoami.your-domain.com

# Each time, look at the "Hostname" line in the output
# It should cycle through different hostnames showing different servers
```

#### **Method C: Check Request Headers**
The whoami app shows your IP address. If you're accessing from different locations or devices, you might see different routing:

```bash
# From different devices or networks, visit your site
# The "RemoteAddr" should show different IPs being routed to different containers
```

### **Method 4: Test High Availability**

Let's test that your app stays up even if one server goes down:

#### **Step 1: Check Current Status**
```bash
# Make sure all 3 replicas are running
docker service ps whoami
```

#### **Step 2: Simulate Server Failure** (Optional - for testing)
```bash
# On one server (like dokploy-ctrl1), stop the Docker service temporarily
# ⚠️ Only do this if you understand the risks!
systemctl stop docker

# Wait 30 seconds
sleep 30

# Check if your website still works
curl http://whoami.your-domain.com
```

#### **Step 3: Verify Recovery**
```bash
# Restart the Docker service
systemctl start docker

# Check that all 3 replicas are running again
docker service ps whoami
```

**Expected Result:** Your website should stay up the entire time, and all 3 replicas should be running again after restart!

### **Method 5: Check Traefik Load Balancing**

Traefik automatically balances traffic between your 3 replicas. You can see this in action:

```bash
# Check Traefik's view of your service
docker exec dokploy-traefik cat /var/log/traefik/traefik.log | grep whoami
```

You should see requests being distributed across different backend servers.

### **What You Should See:**

#### **✅ Success Indicators:**
- **3 containers running** across 3 different servers
- **Load balancing working** - requests go to different containers
- **High availability** - site stays up even if one server fails
- **Automatic recovery** - failed containers restart automatically

#### **❌ Problem Indicators:**
- **Only 1 container** - not using all replicas
- **All containers on one server** - not distributed properly
- **Containers failing** - check Docker logs for errors
- **Site down** - check network connectivity between servers

### **Troubleshooting:**

#### **If Only 1 Container is Running:**
```bash
# Check the service configuration
docker service inspect whoami --pretty

# Look for the "Replicas" setting - should be 3
```

#### **If Containers are Failing:**
```bash
# Check container logs
docker service logs whoami

# Check if there are resource issues
docker system df
```

#### **If Load Balancing Isn't Working:**
```bash
# Check Traefik configuration
docker exec dokploy-traefik cat /etc/traefik/traefik.yml

# Verify the routing rules
docker exec dokploy-traefik cat /etc/dokploy/traefik/dynamic/
```

### **Real-World Benefits:**

#### **✅ What This Gives You:**
- **No single point of failure** - if one server crashes, others keep working
- **Better performance** - 3 containers can handle 3x more traffic
- **Automatic load balancing** - traffic spreads evenly across servers
- **Geographic distribution** - servers in different locations
- **Zero downtime updates** - update without taking site offline

#### **✅ Peace of Mind:**
- **Cloud server goes down?** → Local servers keep your app running
- **Local server loses internet?** → Other servers handle the traffic
- **Traffic spike?** → 3 containers share the load
- **Need maintenance?** → Update one server at a time, site stays up

**Congratulations!** You now have a truly highly available, scalable web application running across multiple servers! 🚀

## Congratulations! 🎊

You just deployed your first application with Dokploy! 

This is the same process you would use for any other application:
1. Put your code in a GitHub repository
2. Create a docker-compose.yaml file
3. Connect it to Dokploy
4. Watch it deploy automatically!

## Next steps to try

1. **Change the domain name** - Try `test.your-domain.com`
2. **Add another app** - Create a second application in the same project
3. **Try a different image** - Change `traefik/whoami` to something else
4. **Add environment variables** - Learn how to add secrets and settings

## Remember

- Dokploy makes deploying apps super easy! 
- Git integration means your app updates automatically when you change the code
- You can deploy any Docker Compose application this way
- Have fun experimenting! 🚀

---

**Need help?** Check the Dokploy documentation or ask in the community forums!

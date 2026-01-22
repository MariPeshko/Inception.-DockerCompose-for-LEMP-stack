## How to run it on WSL

### Issue "This site can’t be reached"

Your browser on Windows doesn't know what mpeshko.42.fr is. To make this work, you need to edit the hosts file on Windows, not WSL.

Path in Windows: C:\Windows\System32\drivers\etc\hosts (open with Notepad as Administrator).

Add the line: 127.0.0.1 mpeshko.42.fr

### Issue: run containers without bind volumes

I run containers without bind volumes and this means that the containers live in complete isolation from each other. There is no "bridge" (Volume) for the /var/www/html folder for nginx and wordpress.

### WSL and Paths Tip

Since your WSL username is mari_unix and your school username is mpeshko, I highly recommend using the $HOME environment variable in your commands. This will make your commands universal: -v $HOME/data/wordpress:/var/www/html
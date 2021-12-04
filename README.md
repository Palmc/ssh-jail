# Para que funcione el chroot hay que añadir las siguientes líneas  al fichero /etc/ssh/sshd_config

Hacemos que el demonio de ssh esté escuchando en ambos puertos
```
Port 22
Port 2222
```


En este primer Match hacemos que si el usuario que está iniciando sesión es el que queremos enjaular lo enjaulamos
```
Match User user1
        ChrootDirectory /home/user1
```

En este Match hacemos que en el puerto 2222 sólo esté disponible sftp 
```
Match LocalPort 2222
        ChrootDirectory /home/user1
        ForceCommand internal-sftp
```

Una vez añadidos los cambios reiniciamos el demonio de ssh
<code>systemctl restart sshd</code>
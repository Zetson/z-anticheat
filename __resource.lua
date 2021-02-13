resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
description 'z-anticheat'

dependency "vrp"

client_scripts{ 
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"cfg.lua",
	"cl_detect.lua",
	"cl_pro.lua",
	"cl_master.lua"
}

server_script "@mysql-async/lib/MySQL.lua"

server_scripts{ 
  "@vrp/lib/utils.lua",
   "sv_detect.lua",
  "sv_master.lua"
}
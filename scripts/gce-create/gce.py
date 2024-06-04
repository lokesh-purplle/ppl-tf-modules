from jinja2 import Template
import os, json, shutil
from pathlib import Path


def preChecks() -> map:
    tf_vars = {}
    if os.environ.get('PROJECT').__eq__("purpllesandboxtier"):
        tf_vars["env"] = "sandbox"
    elif os.environ.get('PROJECT').__eq__("purplleproduction") :
         tf_vars["env"] = "production"

    if os.environ.get('VM_NAME_PREFIX') == "":
        print("VM_NAME_PREFIX is not set, please specify the prefix for the VMs")
        return False
    else:
        tf_vars["vm_name_prefix"] = os.environ.get('VM_NAME_PREFIX')

    if os.environ.get('ADDITIONAL_DISK_SIZE') == 0:
                tf_vars["additional_disk_size"] = 0
                tf_vars["attach_additional_disk"] = "false"
    else:
                tf_vars["additional_disk_size"] = os.environ.get('ADDITIONAL_DISK_SIZE')
                tf_vars["attach_additional_disk"] = "true"
    

    if os.environ.get('MACHINE_TYPE') == "":
        print("MACHINE_TYPE is not set, please specify the machine type for the VMs")
        return False
    else:
        tf_vars["machine_type"] = os.environ.get('MACHINE_TYPE')

    tf_vars["additional_disk_type"] = os.environ.get('ADDITIONAL_DISK_TYPE')
    tf_vars["vpc_subnet"] = os.environ.get('VPC_SUBNET')
    tf_vars["vm_count"] = int(os.environ.get('VM_COUNT'))
    tf_vars["project"] = os.environ.get('PROJECT')
    tf_vars["region"] = os.environ.get('REGION')
    tf_vars["network_tags"] = os.environ.get('NETWORK_TAGS').split(",")
    tf_vars["network_tags"].append("vpn-ssh")
    tf_vars["network_tags"] = json.dumps(tf_vars["network_tags"])
    tf_vars["vm_count"] = json.dumps(list(map(str,[*range(1,int(os.environ.get('VM_COUNT'))+1)])))
    # print(tf_vars["network_tags"])
    # print(tf_vars["vm_count"])
    tf_vars["additional_disk_mount_point"] = os.environ.get('ADDITIONAL_DISK_MOUNT_POINT')
    tf_vars["business_unit"] = os.environ.get('BUSSINESS_UNIT')
    tf_vars["gcp_image"] = os.environ.get('GCP_IMAGE')
    



    return tf_vars
    
def createTfVars(tfvars_file,tf_vars):
    File = open('templates/terraform.tfvars.j2', 'r') 
    content = File.read() 
    File.close() 
    
    # Render the template and pass the variables 
    template = Template(content) 
    rendered_form = template.render(vars=tf_vars) 
    
    print(rendered_form) 
    
    # save the txt file in the form.html 
    output = open(tfvars_file, 'w') 
    output.write(rendered_form) 
    output.close()
     
    


def createBackendTF(backend_tf_file,tf_vars):
    File = open('templates/backend.tf.j2', 'r') 
    content = File.read() 
    File.close() 
    
    # Render the template and pass the variables 
    template = Template(content) 
    rendered_form = template.render(vars=tf_vars) 
    
    print(rendered_form) 
    
    # save the txt file in the form.html 
    output = open(backend_tf_file, 'w') 
    output.write(rendered_form) 
    output.close()
     
def copyTemplate(src,dest):
     print(dest)
     if Path(dest).exists():
      pass
     else:
      shutil.copytree(src,dest)

if __name__ == '__main__':
    print(preChecks())
    tf_vars = preChecks()
    # render_template('templates/index_template.html')
    # '../../tf_vars["business_unit"]/tf_vars["env"]/tf_vars["region"]/instances/tf_vars["vm_name_prefix"]'
    copyTemplate('../../templates/gce', "../../"+tf_vars['business_unit']+"/"+tf_vars['env']+"/"+tf_vars['region']+"/instances/"+tf_vars['vm_name_prefix'])
    createTfVars("../../"+tf_vars['business_unit']+"/"+tf_vars['env']+"/"+tf_vars['region']+"/instances/"+tf_vars['vm_name_prefix']+'/terraform.tfvars',tf_vars)
    createBackendTF("../../"+tf_vars['business_unit']+"/"+tf_vars['env']+"/"+tf_vars['region']+"/instances/"+tf_vars['vm_name_prefix']+'/backend.tf',tf_vars)

(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Bk'Y �]o�0����� �21�BJр�$��
���|��h���>;e����R�i��8>�c�sll��"R�|7�C�عN�݁�N��Z��-C�$X%Q;�6��
[�S���R$#� P������5�J�H�}O�f�"D$�
� \䮨�$��]s�d���8�^#"<�+��zF�t�YvZu��4�z@P��c::�I�L@Ԯ`�%�G-�!/���\�EG�D��(��-��~o٣?eڻ+�nDb��hٺ�g˙�R{��� D޴Z�Vk9��lb��d�f�&1�����UMY�E[�M����P����^�ńb0SGS�{�I!1�@bO����i�4V���t�+e�(7�a��G�.^�c�y�Thfl��L�Y�荷�����Е�\��z(�h�xL��0Z6w��]M1�����յoq�2R���m� rՖ��p���Bh�ʀ���K&z���wbef+K�|&��{����_�z���5�c�.-�kxe���m0��͖p_��T�f��NoGC|�; �qx�j�����^73�?`�U9�����rB��LQ�Qsy��Qh�O0��10�6zڋ�"*��\tn�na:z�T#l|�,4��iT���I�Q��@�_�sm̦[���'�����Z�a����Z��u�ūR�T���w_L8�aA���ߢ�('y���/sy��M	7m����Gi7��}����^����*���p8���p8���p8���p8���_�� (  
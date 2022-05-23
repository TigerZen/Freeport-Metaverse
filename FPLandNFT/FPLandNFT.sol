
// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/Context.sol

pragma solidity >=0.6.0 <0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/introspection/IERC165.sol


pragma solidity >=0.6.0 <0.8.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol

pragma solidity >=0.6.2 <0.8.0;

interface IERC721 is IERC165 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol

pragma solidity >=0.6.2 <0.8.0;

interface IERC721Metadata is IERC721 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol


pragma solidity >=0.6.2 <0.8.0;

interface IERC721Enumerable is IERC721 {

    function totalSupply() external view returns (uint256);

    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) external view returns (uint256);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol

pragma solidity >=0.6.0 <0.8.0;

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

// File: @openzeppelin/contracts/introspection/ERC165.sol

pragma solidity >=0.6.0 <0.8.0;

abstract contract ERC165 is IERC165 {

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity >=0.6.0 <0.8.0;

library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol



pragma solidity >=0.6.2 <0.8.0;

library Address {

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/utils/EnumerableSet.sol



pragma solidity >=0.6.0 <0.8.0;

library EnumerableSet {

    struct Set {
        // Storage of set values
        bytes32[] _values;

        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) { // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            bytes32 lastvalue = set._values[lastIndex];

            // Move the last value to the index where the value to delete is
            set._values[toDeleteIndex] = lastvalue;
            // Update the index for the moved value
            set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        require(set._values.length > index, "EnumerableSet: index out of bounds");
        return set._values[index];
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }


    // UintSet

    struct UintSet {
        Set _inner;
    }

    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }
}

// File: @openzeppelin/contracts/utils/EnumerableMap.sol



pragma solidity >=0.6.0 <0.8.0;

library EnumerableMap {

    struct MapEntry {
        bytes32 _key;
        bytes32 _value;
    }

    struct Map {
        // Storage of map keys and values
        MapEntry[] _entries;

        // Position of the entry defined by a key in the `entries` array, plus 1
        // because index 0 means a key is not in the map.
        mapping (bytes32 => uint256) _indexes;
    }

    function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
        // We read and store the key's index to prevent multiple reads from the same storage slot
        uint256 keyIndex = map._indexes[key];

        if (keyIndex == 0) { // Equivalent to !contains(map, key)
            map._entries.push(MapEntry({ _key: key, _value: value }));
            // The entry is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            map._indexes[key] = map._entries.length;
            return true;
        } else {
            map._entries[keyIndex - 1]._value = value;
            return false;
        }
    }

    /**
     * @dev Removes a key-value pair from a map. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function _remove(Map storage map, bytes32 key) private returns (bool) {
        // We read and store the key's index to prevent multiple reads from the same storage slot
        uint256 keyIndex = map._indexes[key];

        if (keyIndex != 0) { // Equivalent to contains(map, key)
            // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
            // in the array, and then remove the last entry (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = keyIndex - 1;
            uint256 lastIndex = map._entries.length - 1;

            // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
            // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.

            MapEntry storage lastEntry = map._entries[lastIndex];

            // Move the last entry to the index where the entry to delete is
            map._entries[toDeleteIndex] = lastEntry;
            // Update the index for the moved entry
            map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based

            // Delete the slot where the moved entry was stored
            map._entries.pop();

            // Delete the index for the deleted slot
            delete map._indexes[key];

            return true;
        } else {
            return false;
        }
    }

    function _contains(Map storage map, bytes32 key) private view returns (bool) {
        return map._indexes[key] != 0;
    }

    function _length(Map storage map) private view returns (uint256) {
        return map._entries.length;
    }

    function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
        require(map._entries.length > index, "EnumerableMap: index out of bounds");

        MapEntry storage entry = map._entries[index];
        return (entry._key, entry._value);
    }

    function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
        uint256 keyIndex = map._indexes[key];
        if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
        return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
    }

    function _get(Map storage map, bytes32 key) private view returns (bytes32) {
        uint256 keyIndex = map._indexes[key];
        require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
        return map._entries[keyIndex - 1]._value; // All indexes are 1-based
    }

    function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
        uint256 keyIndex = map._indexes[key];
        require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
        return map._entries[keyIndex - 1]._value; // All indexes are 1-based
    }

    // UintToAddressMap

    struct UintToAddressMap {
        Map _inner;
    }

    function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
        return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
    }

    function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
        return _remove(map._inner, bytes32(key));
    }

    function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
        return _contains(map._inner, bytes32(key));
    }

    function length(UintToAddressMap storage map) internal view returns (uint256) {
        return _length(map._inner);
    }

    function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
        (bytes32 key, bytes32 value) = _at(map._inner, index);
        return (uint256(key), address(uint160(uint256(value))));
    }

    function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
        (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
        return (success, address(uint160(uint256(value))));
    }

    function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
        return address(uint160(uint256(_get(map._inner, bytes32(key)))));
    }

    function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
        return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
    }
}

// File: @openzeppelin/contracts/utils/Strings.sol



pragma solidity >=0.6.0 <0.8.0;

library Strings {
    /**
     * @dev Converts a `uint256` to its ASCII `string` representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = bytes1(uint8(48 + temp % 10));
            temp /= 10;
        }
        return string(buffer);
    }
}

// File: @openzeppelin/contracts/token/ERC721/ERC721.sol



pragma solidity >=0.6.0 <0.8.0;
/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
    using SafeMath for uint256;
    using Address for address;
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.UintToAddressMap;
    using Strings for uint256;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from holder address to their (enumerable) set of owned tokens
    mapping (address => EnumerableSet.UintSet) private _holderTokens;

    // Enumerable mapping from token ids to their owners
    EnumerableMap.UintToAddressMap private _tokenOwners;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Optional mapping for token URIs
    mapping (uint256 => string) private _tokenURIs;

    // Base URI
    string private _baseURI;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _holderTokens[owner].length();
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        //require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.

        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function baseURI() public view virtual returns (string memory) {
        return _baseURI;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
        return _holderTokens[owner].at(index);
    }

    function totalSupply() public view virtual override returns (uint256) {
        // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
        return _tokenOwners.length();
    }

    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        (uint256 tokenId, ) = _tokenOwners.at(index);
        return tokenId;
    }

    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _tokenOwners.contains(tokenId);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
    }

    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _holderTokens[to].add(tokenId);

        _tokenOwners.set(tokenId, to);

        emit Transfer(address(0), to, tokenId);
    }

    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId); // internal owner

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        // Clear metadata (if any)
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }

        _holderTokens[owner].remove(tokenId);

        _tokenOwners.remove(tokenId);

        emit Transfer(owner, address(0), tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _holderTokens[from].remove(tokenId);
        _holderTokens[to].add(tokenId);

        _tokenOwners.set(tokenId, to);

        emit Transfer(from, to, tokenId);
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function _setBaseURI(string memory baseURI_) internal virtual {
        _baseURI = baseURI_;
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        private returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }
        bytes memory returndata = to.functionCall(abi.encodeWithSelector(
            IERC721Receiver(to).onERC721Received.selector,
            _msgSender(),
            from,
            tokenId,
            _data
        ), "ERC721: transfer to non ERC721Receiver implementer");
        bytes4 retval = abi.decode(returndata, (bytes4));
        return (retval == _ERC721_RECEIVED);
    }

    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
}

// File: @openzeppelin/contracts/access/Ownable.sol



pragma solidity >=0.6.0 <0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface FreeURI{
    function GaiaMint(address _Addr, uint8 _typeID, uint8 _rarityID) external;
    function GettokenURI(uint _typeID) external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
	
	function InitLandType(uint _AreaNO, uint _LandNO) external view returns (uint8);
	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
	function CheckTraitData(uint tokenId) external view returns (uint8 stype, uint publicMTC, uint redeemMTC, address ArinaChain, uint CitizensQuota);
}

interface FPAS{
    function GaiaMint(address _Addr, uint8 _typeID, uint8 _rarityID) external;
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 tokenId) external;
	function GetSSBtokenID(uint _tokenID) external view returns (bool);
	function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
	function CheckTraitData(uint tokenId) external view returns (uint8 stype, uint8 srarity);
}

pragma solidity ^0.7.0;

/**
 * @title Freeport LandNFT contract
 * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
 */
contract FPLandNFT is ERC721, Ownable {
    using SafeMath for uint256;

    string public Freeport_PROVENANCE = "";
    uint256 public startingIndexBlock;
    uint256 public startingIndex;
    uint256 public LandPrice = 500 * 10 ** uint(18);
	
	uint256 public ActiveTime = 1651068000;   //1651240800 = Fri Apr 29 2022 22:00:00 UTC+0800

    bool public typeURIIsActive = true;
    bool public saleIsActive = true;

	address _FreeURIIDAddr = 0xf40E4D4A5d8A1f54fbD0775598DDdF36CD5131D9;
	address _FreeURITypeAddr = 0x665E83800eb0563556a4535c227C7f728A50bDFE;
	address _InitLandTypeAddr = 0xdFD9c85ef14AA7647876a2D6B1f8eD31e880E1eD;
	address _MTCAddr = 0x5F1D2cfDEB097B83eD2f35Cf3E827DE2b700F05a;
	address _Gaia1 = 0x7a7c19aA787B547582402e11434024447c489F4c;
	address _Gaia2;
	address _Gaia3;
	
    struct XTraitData {
        uint8 LandType;
        address ARAAddr;
        uint AreaNO;
        uint LandNO;
        uint CoordinateX;
        uint CoordinateY;
        uint ARADailyProfit;
    }

    uint public TotalMinted;
    uint public TotalMTCMinted;
    uint public TotalSSBMinted;
	
    mapping (uint => XTraitData) public TraitData;	
	mapping (uint => mapping (uint => uint)) public LandInfoForID;

	mapping (uint8 => uint) LandARAProfit;
    mapping (uint => bool) public LIsAreaMintable;
	mapping (uint => mapping (uint => bool)) public LIsLandNOMinted;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
		LandARAProfit[6] = 10;
		LandARAProfit[7] = 5;
		LandARAProfit[8] = 1;
		setAreaMintableOff();
    }

    function Gaia1() public view virtual returns (address) {
        return _Gaia1;
    }

    function Gaia2() public view virtual returns (address) {
        return _Gaia2;
    }	

    function Gaia3() public view virtual returns (address) {
        return _Gaia3;
    }
	
    modifier onlyGaia() {
        require(Gaia1() == _msgSender() || Gaia2() == _msgSender() || Gaia3() == _msgSender() || owner() == _msgSender(), "Ownable: caller is not the Gaia");
        _;
    }

	function setTime(uint256 _ActiveTime) public onlyOwner{
        ActiveTime = _ActiveTime;
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }

    function withdrawETH(uint _ETHWEI) public onlyOwner {
        msg.sender.transfer(_ETHWEI);
    }

    function takeTokensToManager(address tokenAddr) external onlyOwner{
        uint _thisTokenBalance = FreeURI(tokenAddr).balanceOf(address(this));
        require(FreeURI(tokenAddr).transfer(msg.sender, _thisTokenBalance));
    }

    function withdrawNFTTokens(address NFTAddr, uint _tokenID) external onlyOwner{
		FPAS(NFTAddr).transferFrom(address(this), msg.sender, _tokenID);
    }

    function setProvenanceHash(string memory provenanceHash) public onlyOwner {
        Freeport_PROVENANCE = provenanceHash;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _setBaseURI(baseURI);
    }

    function fliptypeURIState() public onlyOwner {
        typeURIIsActive = !typeURIIsActive;
    }
	
    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

	function setAreaMintableOff() internal{
        for (uint i = 0; i < 26; i++){
		    LIsAreaMintable[i] = false;
        }
    }
	
	function flipAreaMintable(uint _AreaNO) public onlyOwner {
        LIsAreaMintable[_AreaNO] = !LIsAreaMintable[_AreaNO];
    }
	
    function CheckAreaMintable(uint _AreaNO) public view returns (bool) {
		return  LIsAreaMintable[_AreaNO];
    }

    function IsLandMinted(uint _AreaNO, uint _LandNO) public view returns (bool) {
        return LIsLandNOMinted[_AreaNO][_LandNO];
    }

    function CheckMintedBatch(uint _AreaNO, uint[] memory _LandNO) public view returns (bool[] memory) {
        uint _LandNOLength = _LandNO.length;

		bool[] memory getCheckMinted = new bool[](_LandNOLength);
        for (uint i = 0; i < _LandNOLength; i++){
		    getCheckMinted[i] = LIsLandNOMinted[_AreaNO][_LandNO[i]];
        }
        return getCheckMinted;
    }
	
    function setLandMinted(uint _AreaNO, uint _LandNO) internal {
        LIsLandNOMinted[_AreaNO][_LandNO] = true;
    }
	
    function OwnersetLandMinted(uint _AreaNO, uint _LandNO) public onlyOwner {
        LIsLandNOMinted[_AreaNO][_LandNO] = true;
    }

    function setURIAddr(address _sFreeURIIDAddr, address _sFreeURITypeAddr, address _sInitLandTypeAddr, address _sMTCAddr) public onlyOwner {
        _FreeURIIDAddr = _sFreeURIIDAddr;
        _FreeURITypeAddr = _sFreeURITypeAddr;
		_InitLandTypeAddr = _sInitLandTypeAddr;
        _MTCAddr = _sMTCAddr;
    }

    function setGaiaAddr(address _sGaia1, address _sGaia2, address _sGaia3) public onlyOwner {
        _Gaia1 = _sGaia1;
		_Gaia2 = _sGaia2;
		_Gaia3 = _sGaia3;
    }

    function CheckLandPrice() public view returns (uint) {
        return LandPrice;
    }

    function setLandPrice(uint _amontsMTC) public onlyGaia {
        LandPrice = _amontsMTC * 10 ** 18;
    }
	
    function GaiaTransfer(address from, address to, uint _tokenID) public onlyGaia {
		_transfer(from, to, _tokenID);
    }

    function setTraitDataGaia(uint _tokenID, uint8 stype, address ArinaChain, uint _AreaNO, uint _LandNO, uint _CoordinateX, uint _CoordinateY, uint _ARADailyProfit) public onlyGaia {
        TraitData[_tokenID].LandType = stype;
		TraitData[_tokenID].ARAAddr = ArinaChain;
		TraitData[_tokenID].AreaNO = _AreaNO;
		TraitData[_tokenID].LandNO = _LandNO;
		TraitData[_tokenID].CoordinateX = _CoordinateX;
		TraitData[_tokenID].CoordinateY = _CoordinateY;
		TraitData[_tokenID].ARADailyProfit = _ARADailyProfit;
    }

    function setTraitData(uint _tokenID, uint8 stype, address ArinaChain, uint _AreaNO, uint _LandNO, uint _CoordinateX, uint _CoordinateY, uint _ARADailyProfit) internal {
        TraitData[_tokenID].LandType = stype;
		TraitData[_tokenID].ARAAddr = ArinaChain;
		TraitData[_tokenID].AreaNO = _AreaNO;
		TraitData[_tokenID].LandNO = _LandNO;
		TraitData[_tokenID].CoordinateX = _CoordinateX;
		TraitData[_tokenID].CoordinateY = _CoordinateY;
		TraitData[_tokenID].ARADailyProfit = _ARADailyProfit;
    }

    function mintLandMTC(uint _AreaNO, uint _LandNO) public {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");
        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
        require(_LandNO >= 0 && _LandNO < 10000, "LandNO error.");
        address inputAddr = msg.sender;
        require(FreeURI(_MTCAddr).transferFrom(inputAddr, address(this), LandPrice), "Freeport Land Mint : Value error.");

		FPLandMintInternal(_AreaNO, _LandNO, inputAddr);
    }
	
    function mintLandMTCBatch(uint _AreaNO, uint[] memory _LandNO) public {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");
        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
		
        uint _LandNOLength = _LandNO.length;
        for (uint i = 0; i < _LandNOLength; i++){
		    require(_LandNO[i] >= 0 && _LandNO[i] < 10000, "LandNO error.");
        }
		
        address inputAddr = msg.sender;
        require(FreeURI(_MTCAddr).transferFrom(inputAddr, address(this), LandPrice.mul(_LandNOLength)), "Freeport Land Mint : Value error.");
		
        for (uint i = 0; i < _LandNOLength; i++){
		    FPLandMintInternal(_AreaNO, _LandNO[i], inputAddr);
        }
    }
	
    function FPLandMintInternal(uint _AreaNO, uint _LandNO, address inputAddr) internal {
        require(!IsLandMinted(_AreaNO, _LandNO), "Sale must be active to mint Freeport Land");
		uint8 _sLandType = FreeURI(_InitLandTypeAddr).InitLandType(_AreaNO, _LandNO);
		
		uint mintIndex = totalSupply();
		_safeMint(inputAddr, mintIndex);
		LandInfoForID[_AreaNO][_LandNO] = mintIndex;
		
		uint XCoord = _LandNO % 100;
		uint YCoord = _LandNO / 100;
		setTraitData(mintIndex, _sLandType, inputAddr, _AreaNO, _LandNO, XCoord, YCoord, LandARAProfit[_sLandType] * 10 ** 18);
		setLandMinted(_AreaNO, _LandNO);
		
		TotalMinted += 1;

        if (_sLandType <= 5) {
			TotalMTCMinted += 1;
        }else{
			TotalSSBMinted += 1;
		}
    }

    function FPLandMint(address _Addr, uint _AreaNO, uint _LandNO, uint8 _sLandType) public onlyGaia {
        require(!IsLandMinted(_AreaNO, _LandNO), "Sale must be active to mint Freeport Land");
		uint mintIndex = totalSupply();
		_safeMint(_Addr, mintIndex);
		LandInfoForID[_AreaNO][_LandNO] = mintIndex;
		uint XCoord = _LandNO % 100;
		uint YCoord = _LandNO / 100;
		setTraitData(mintIndex, _sLandType, _Addr, _AreaNO, _LandNO, XCoord, YCoord, LandARAProfit[_sLandType] * 10 ** 18);
		setLandMinted(_AreaNO, _LandNO);
		
		TotalMinted += 1;

        if (_sLandType <= 5) {
			TotalMTCMinted += 1;
        }else{
			TotalSSBMinted += 1;
		}
    }

    function GaiaMintLand(address inputAddr, uint _AreaNO, uint _LandNO) public onlyGaia {
        require(IsTimeActive() && CheckAreaMintable(_AreaNO), "Sale must be active to mint Freeport Land");
        require(_AreaNO > 0 && _AreaNO <= 25, "AreaNO error.");
        require(_LandNO >= 0 && _LandNO < 10000, "LandNO error.");
		FPLandMintInternal(_AreaNO, _LandNO, inputAddr);
    }
	
    function checkLandTypeByID(uint tokenId) public view returns (
		uint8 stype
	) {
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return TraitData[tokenId].LandType;
    }
	
    function checkLandTypeByLandNO(uint _AreaNO, uint _LandNO) public view returns (
		uint8 stype
	) {
        if(LandInfoForID[_AreaNO][_LandNO] != 0){
        	return checkLandTypeByID(LandInfoForID[_AreaNO][_LandNO]);
		}else{
			return FreeURI(_InitLandTypeAddr).InitLandType(_AreaNO, _LandNO);
		}
    }

    function CheckLandTypeByLandBatch(uint _AreaNO, uint[] memory _LandNO) public view returns (uint8[] memory) {
        uint _LandNOLength = _LandNO.length;

		uint8[] memory getLandType = new uint8[](_LandNOLength);
        for (uint i = 0; i < _LandNOLength; i++){
		    getLandType[i] = checkLandTypeByLandNO(_AreaNO, _LandNO[i]);
        }
        return getLandType;
    }

    function checkOwnerLandNO(uint _AreaNO, uint _LandNO) public view returns (
		address LandOwner
	) {
        if(LandInfoForID[_AreaNO][_LandNO] != 0){
            return ownerOf(LandInfoForID[_AreaNO][_LandNO]);
        }else{
            return address(0);
		}
    }

    function checkLandNOIsOwner(address addr, uint _AreaNO, uint _LandNO) public view returns (
		bool
	) {
        if(LandInfoForID[_AreaNO][_LandNO] != 0){
            return ownerOf(LandInfoForID[_AreaNO][_LandNO]) == addr;
        }else{
            return false;
		}
    }

    function CheckIsOwnerBatch(address addr, uint _AreaNO, uint[] memory _LandNO) public view returns (bool[] memory) {
        uint _LandNOLength = _LandNO.length;

		bool[] memory getCheckMinted = new bool[](_LandNOLength);
        for (uint i = 0; i < _LandNOLength; i++){
		    getCheckMinted[i] = checkLandNOIsOwner(addr, _AreaNO, _LandNO[i]);
        }
        return getCheckMinted;
    }
	
    function CheckAllTokenIDOwner(address addr) public view returns (uint[] memory) {
        uint256 tokenbalanceOf = balanceOf(addr);
		uint[] memory getTokenIDArray = new uint[](tokenbalanceOf);

        for (uint i = 0; i < tokenbalanceOf; i++){
		    getTokenIDArray[i] = tokenOfOwnerByIndex(addr, i);
        }
		return getTokenIDArray;
    }
	
    function CheckAreaLandByID(uint tokenId) public view returns (
		uint _AreaNO,
		uint _LandNO
	) {
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return (TraitData[tokenId].AreaNO, TraitData[tokenId].LandNO);
    }

    function CheckTraitData(uint tokenId) public view returns (
		uint8 stype,
		address ArinaChain,
		uint _AreaNO,
		uint _LandNO,
		uint _CoordinateX,
		uint _CoordinateY,
		uint _ARADailyProfit
	) {
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return (TraitData[tokenId].LandType, TraitData[tokenId].ARAAddr, TraitData[tokenId].AreaNO, TraitData[tokenId].LandNO, TraitData[tokenId].CoordinateX, TraitData[tokenId].CoordinateY, TraitData[tokenId].ARADailyProfit);
    }

    function AllMintAmounts() public view returns (uint[] memory) {
		uint[] memory getAllMint = new uint[](3);
		getAllMint[0] = TotalMinted;
		getAllMint[1] = TotalMTCMinted;
		getAllMint[2] = TotalSSBMinted;
		return getAllMint;
    }

    function setStartingIndex() public {
        require(startingIndex == 0, "Starting index is already set");
        require(startingIndexBlock != 0, "Starting index block must be set");
        
        startingIndex = uint(blockhash(startingIndexBlock));
        // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
        if (block.number.sub(startingIndexBlock) > 255) {
            startingIndex = uint(blockhash(block.number - 1));
        }
        // Prevent default sequence
        if (startingIndex == 0) {
            startingIndex = startingIndex.add(1);
        }
    }

    function emergencySetStartingIndexBlock() public onlyOwner {
        require(startingIndex == 0, "Starting index is already set");
        startingIndexBlock = block.number;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
		if(IstypeURIActive()){
		    uint _typeID = uint(TraitData[tokenId].LandType);
            return FreeURI(_FreeURITypeAddr).GettokenURI(_typeID);
		}else{
            return FreeURI(_FreeURIIDAddr).GettokenURI(tokenId);
		}
    }
	
    function IstypeURIActive() public view returns (bool) {
        return typeURIIsActive;
    }
	
    function IsTimeActive() public view returns (bool) {
        return block.timestamp >= ActiveTime;
    }
	
    function rand(bytes memory seed, uint bottom, uint top) internal pure returns(uint){
        require(top >= bottom, "bottom > top");
        if(top == bottom){
            return top;
        }
        uint _range = top.sub(bottom);

        uint n = uint(keccak256(seed));
        return n.mod(_range).add(bottom).add(1);
    }
}
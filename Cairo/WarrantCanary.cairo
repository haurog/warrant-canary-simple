%lang starknet
%builtins range_check

struct warrantCanary:
    member ID : felt
    member expirationTime : felt
    member lastUpdatedInBlock : felt
    member purpose : felt
    member warrantCanaryOwner : felt
end

@storage_var
func warrantCanaries(id : felt) -> (warrantCanary : warrantCanary):
end

@storage_var
func IDsOwned(address : felt) -> (IDs : felt):
end

func create_WarrantCanary{syscall_ptr : felt*, range_check_ptr}(
        epirationTime_ : felt, purpose_ : felt):
    let a = 1
    return ()
end
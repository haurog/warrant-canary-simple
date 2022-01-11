%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func IDcount() -> (IDcount : felt):
end

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

func create_WarrantCanary{syscall_ptr : felt*, range_check_ptr, pedersen_ptr : HashBuiltin*}(
        expirationTime_ : felt, purpose_ : felt):
    let (count) = IDcount.read()
    let wc = warrantCanary(
        ID = count,
        expirationTime = expirationTime_,
        lastUpdatedInBlock = 0,  # TODO: finish this logic
        purpose = purpose_,
        warrantCanaryOwner = 0   # TODO: finish this logic
        )

    warrantCanaries.write(count, wc)
    #  IDsOwned.write   TODO: add the new ID to the already owned ones
    IDcount.write(count + 1)

    return ()
end